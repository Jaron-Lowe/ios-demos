//
//  MapToVoid.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/22/21.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
}
