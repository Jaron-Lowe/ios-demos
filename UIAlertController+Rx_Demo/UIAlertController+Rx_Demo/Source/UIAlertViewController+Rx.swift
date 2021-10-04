//
//  UIAlertController+Rx.swift
//
//  Created by Jaron Lowe on 8/19/21.
//

import UIKit
import RxSwift

struct RxAlertAction<T> {
    
    let title: String?
    let style: UIAlertAction.Style
    let result: T?
    
    static func cancelAction(title: String) -> RxAlertAction {
        return RxAlertAction(title: title, style: .cancel, result: nil)
    }
    
}

extension Reactive where Base: UIAlertController {
    
    static func presentAlert<T>(viewController: UIViewController?, title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, popoverView: UIView? = nil, popoverDirection: UIPopoverArrowDirection = .any, animated: Bool = true, actions: [RxAlertAction<T>]) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            
            guard let viewController = viewController else {
                observer.onCompleted()
                return Disposables.create()
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            actions.map { rxAction in
                UIAlertAction(title: rxAction.title, style: rxAction.style, handler: { _ in
                    if let result = rxAction.result { observer.onNext(result) }
                    observer.onCompleted()
                })
            }
            .forEach(alertController.addAction)

            if let popoverView = popoverView {
                alertController.popoverPresentationController?.sourceView = popoverView
                alertController.popoverPresentationController?.sourceRect = popoverView.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = popoverDirection
            }
            
            viewController.present(alertController, animated: animated, completion: nil)

            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
