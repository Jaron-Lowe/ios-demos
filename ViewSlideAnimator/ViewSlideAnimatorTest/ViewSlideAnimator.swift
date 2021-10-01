//
//  ViewSlideAnimator.swift
//  ViewSlideAnimatorTest
//
//  Created by Jaron Lowe on 9/4/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

/// An animator that controls how a view should slide over one of its pinned edges.
public final class ViewSlideAnimator {
    
    // MARK: Properties
    
    private weak var view: UIView?
    private weak var toggleButton: UIButton?
    private let configuration: Configuration
    private let shownEdgeConstraint: NSLayoutConstraint?
    private lazy var hiddenEdgeConstraint: NSLayoutConstraint? = {
        if let constraint = shownEdgeConstraint {
            let firstItemIsView = ((constraint.firstItem as? UIView) == view)
            return NSLayoutConstraint(
                item: constraint.firstItem as Any,
                attribute: firstItemIsView ? configuration.edge.hiddenAttribute : constraint.firstAttribute,
                relatedBy: .equal,
                toItem: constraint.secondItem,
                attribute: firstItemIsView ? constraint.secondAttribute : configuration.edge.hiddenAttribute,
                multiplier: 1.0,
                constant: 0.0
            )
        } else {
            return nil
        }
    }()
    private let disposeBag = DisposeBag()
    
    /// A flag indicating whether the view is slid open.
    public private(set) var isOpen: Bool = true
    
    // MARK: Init
    
    /// Creates a new ViewSlideAnimator that controls a view's ability to slide over an edge.
    /// - Parameters:
    ///   - view: The view that will be sliding.
    ///   - toggleButton: A button that will toggle the view's slide state.
    ///   - configuration: The configuration that specifies how the animator controls the view.
    public init(view: UIView, toggleButton: UIButton?, configuration: Configuration) {
        self.view = view
        self.toggleButton = toggleButton
        self.configuration = configuration
        shownEdgeConstraint = configuration.edge.findConstraint(view: view)
        setUpToggleButtonObserver(toggleButton: toggleButton)
        setUpGestureObservers()
        
        if configuration.shouldStartOpen {
            open(animated: false)
        } else {
            close(animated: false)
        }
    }
    
    // MARK: Methods
    
    /// Toggles whether the view is open, or not.
    /// - Parameter animated: Whether to transition using an animation.
    public func toggle(animated: Bool = true) {
        if isOpen {
            close(animated: animated)
        } else {
            open(animated: animated)
        }
    }
    
    /// Makes the view slide open.
    /// - Parameter animated: Whether to transition using an animation.
    public func open(animated: Bool = true) {
        isOpen = true
        view?.isHidden = false
        view?.alpha = 0.0
        toggleButton?.isHidden = false
        toggleButton?.alpha = 1.0
        
        hiddenEdgeConstraint?.isActive = false
        shownEdgeConstraint?.isActive = true
        
        let animations = { [weak self] in
            self?.view?.superview?.layoutIfNeeded()
            self?.view?.alpha = 1.0
            if self?.configuration.shouldHideToggleButton == true {
                self?.toggleButton?.alpha = 0.0
            }
        }
        
        let completion: ((Bool) -> Void) = { [weak self] _ in
            if self?.configuration.shouldHideToggleButton == true {
                self?.toggleButton?.isHidden = true
            }
        }
        
        if animated {
            UIView.animate(
                withDuration: configuration.animationDuration,
                delay: 0.0,
                options: [.curveEaseInOut],
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
    }
    
    /// Makes the view slide closed.
    /// - Parameter animated: Whether to transition using an animation.
    public func close(animated: Bool = true) {
        isOpen = false
        view?.alpha = 1.0
        toggleButton?.isHidden = false
        
        shownEdgeConstraint?.isActive = false
        hiddenEdgeConstraint?.isActive = true
        
        let animations = { [weak self] in
            self?.view?.superview?.layoutIfNeeded()
            self?.view?.alpha = 0.0
            self?.toggleButton?.alpha = 1.0
        }
        
        let completion: ((Bool) -> Void) = { [weak self] _ in
            self?.view?.isHidden = true
        }
        
        if animated {
            UIView.animate(
                withDuration: configuration.animationDuration,
                delay: 0.0,
                options: [.curveEaseInOut],
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
    }
    
}

// MARK: Private Methods

private extension ViewSlideAnimator {
    
    func setUpToggleButtonObserver(toggleButton: UIButton?) {
        toggleButton?.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    func setUpGestureObservers() {
        if configuration.dismissGestures.contains(.tap) {
            view?.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.close(animated: true)
                })
                .disposed(by: disposeBag)
        }
        
        if configuration.dismissGestures.contains(.swipe) {
            let direction = configuration.edge.swipeDirection
            view?.rx.swipeGesture(direction)
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.close(animated: true)
                })
                .disposed(by: disposeBag)
        }
    }
    
}

// MARK: Configuration

public extension ViewSlideAnimator {
    
    /// A object used to define the behavior of the slide animator.
    struct Configuration {
        
        /// The edge that the view slides over.
        public let edge: Edge
        
        /// What gestures, if any, should be used to hide the view.
        public let dismissGestures: DismissGestures
        
        /// Flag indicaing whether the view should start open.
        public let shouldStartOpen: Bool
        
        /// Flag indicating whether the toggle button should hide when the view is slid open.
        public let shouldHideToggleButton: Bool
        
        /// The time used to perform the show and hide animations.
        public let animationDuration: TimeInterval
        
        public init(edge: Edge, gestures: DismissGestures, shouldStartOpen: Bool = false, shouldHideToggleButton: Bool = true, animationDuration: TimeInterval = 0.25) {
            self.edge = edge
            self.dismissGestures = gestures
            self.animationDuration = animationDuration
            self.shouldStartOpen = shouldStartOpen
            self.shouldHideToggleButton = shouldHideToggleButton
        }
        
    }
    
}

// MARK: Edge

public extension ViewSlideAnimator {
    
    enum Edge {
        
        /// The view slides over the top edge.
        case top
        /// The view slides over the leading edge.
        case leading
        /// The view slides over the trailing edge.
        case trailing
        /// The view slides over the bottom edge.
        case bottom
        
        fileprivate var shownAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .top:
                return .top
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .bottom:
                return .bottom
            }
        }
        
        fileprivate var hiddenAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .top:
                return .bottom
            case .leading:
                return .trailing
            case .trailing:
                return .leading
            case .bottom:
                return .top
            }
        }
        
        fileprivate var swipeDirection: SwipeDirection {
            switch self {
            case .top:
                return .up
            case .leading:
                return .left
            case .trailing:
                return .right
            case .bottom:
                return .down
            }
        }
        
        fileprivate func findConstraint(view: UIView?) -> NSLayoutConstraint? {
            return view?.superview?.constraints.first {
                ($0.firstItem === view && $0.firstAttribute == shownAttribute)
                    || ($0.secondItem === view && $0.secondAttribute == shownAttribute)
            }
        }
        
    }
    
}

// MARK: DismissGestures

public extension ViewSlideAnimator {
    
    /// An option set to define the gestures used to hide the window.
    struct DismissGestures: OptionSet {
        
        public let rawValue: Int
        
        /// Tapping on a non-active area of the window will hide the window.
        public static let tap = DismissGestures(rawValue: 1 << 0)
        
        /// Swiping anywhere on the window will dismiss it.
        public static let swipe = DismissGestures(rawValue: 1 << 1)
        
        /// All supported gestures within the window will hide it.
        public static let all: DismissGestures = [.tap, .swipe]
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
    }
    
}
