//
//  ViewController.swift
//  ViewSlideAnimatorTest
//
//  Created by Jaron Lowe on 9/4/21.
//

import UIKit

final class ViewController: UIViewController {

    
    // MARK: Properties
    
    private let contentView = View()
    
    private var animatorOne: ViewSlideAnimator?
    private var animatorTwo: ViewSlideAnimator?
    private var animatorThree: ViewSlideAnimator?
    private var animatorFour: ViewSlideAnimator?
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if #available(iOS 13, *) {
            setUpWithTraits(traits: traitCollection)
        }
    }
    
    override func loadView() {
        view = contentView
    }
    
    // MARK: UITraitEnvironment

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setUpWithTraits(traits: traitCollection)
    }


}

// MARK: Private Methods

private extension ViewController {
    
    func setUpWithTraits(traits: UITraitCollection) {
        // Ensure that the view is set up with the trait change before instantiating ViewSlideAnimators.
        contentView.setUpWithTraits(traits: traits)
        
        let shouldStartOpenOne = animatorOne?.isOpen ?? false
        let shouldStartOpenTwo = animatorTwo?.isOpen ?? false
        let shouldStartOpenThree = animatorThree?.isOpen ?? false
        let shouldStartOpenFour = animatorFour?.isOpen ?? false
        
        if traits.verticalSizeClass == .regular {
            let configOne = ViewSlideAnimator.Configuration(edge: .top, gestures: .swipe, shouldStartOpen: shouldStartOpenOne)
            let configTwo = ViewSlideAnimator.Configuration(edge: .leading, gestures: .swipe, shouldStartOpen: shouldStartOpenTwo)
            let configThree = ViewSlideAnimator.Configuration(edge: .trailing, gestures: .swipe, shouldStartOpen: shouldStartOpenThree)
            let configFour = ViewSlideAnimator.Configuration(edge: .bottom, gestures: .swipe, shouldStartOpen: shouldStartOpenFour)
            
            animatorOne = ViewSlideAnimator(view: contentView.oneLabel, toggleButton: contentView.oneButton, configuration: configOne)
            animatorTwo = ViewSlideAnimator(view: contentView.twoLabel, toggleButton: contentView.twoButton, configuration: configTwo)
            animatorThree = ViewSlideAnimator(view: contentView.threeLabel, toggleButton: contentView.threeButton, configuration: configThree)
            animatorFour = ViewSlideAnimator(view: contentView.fourLabel, toggleButton: contentView.fourButton, configuration: configFour)
        } else {
            let configOne = ViewSlideAnimator.Configuration(edge: .trailing, gestures: .swipe, shouldStartOpen: shouldStartOpenOne, shouldHideToggleButton: false)
            let configTwo = ViewSlideAnimator.Configuration(edge: .trailing, gestures: .swipe, shouldStartOpen: shouldStartOpenTwo, shouldHideToggleButton: false)
            let configThree = ViewSlideAnimator.Configuration(edge: .trailing, gestures: .swipe, shouldStartOpen: shouldStartOpenThree, shouldHideToggleButton: false)
            let configFour = ViewSlideAnimator.Configuration(edge: .trailing, gestures: .swipe, shouldStartOpen: shouldStartOpenFour, shouldHideToggleButton: false)
            
            animatorOne = ViewSlideAnimator(view: contentView.oneLabel, toggleButton: contentView.oneButton, configuration: configOne)
            animatorTwo = ViewSlideAnimator(view: contentView.twoLabel, toggleButton: contentView.twoButton, configuration: configTwo)
            animatorThree = ViewSlideAnimator(view: contentView.threeLabel, toggleButton: contentView.threeButton, configuration: configThree)
            animatorFour = ViewSlideAnimator(view: contentView.fourLabel, toggleButton: contentView.fourButton, configuration: configFour)
            
        }
    }
    
}

