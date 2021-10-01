//
//  View.swift
//  WindowSlideDirectorTest
//
//  Created by Jaron Lowe on 9/6/21.
//

import UIKit

final class View: UIView {
    
    // MARK: Properties
    
    private(set) lazy var oneButton = UIButton()
    private(set) lazy var twoButton = UIButton()
    private(set) lazy var threeButton = UIButton()
    private(set) lazy var fourButton = UIButton()
    
    private(set) lazy var oneLabel = UILabel()
    private(set) lazy var twoLabel = UILabel()
    private(set) lazy var threeLabel = UILabel()
    private(set) lazy var fourLabel = UILabel()
    
    private var allViews: [UIView] {
        return [
            oneButton, twoButton, threeButton, fourButton,
            oneLabel, twoLabel, threeLabel, fourLabel
        ]
    }
    
    // MARK: Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        applyStyles()
    }
    
    // MARK: Methods
    
    func setUpWithTraits(traits: UITraitCollection) {
        deconstructSubviews()
        setUpSubviews(traits: traits)
        setUpConstraints(traits: traits)
    }
    
}

// MARK: Private Methods

private extension View {

    func deconstructSubviews() {
        allViews.forEach { $0.removeFromSuperview() }
    }
    
    func setUpSubviews(traits: UITraitCollection) {
        allViews.forEach { addSubview($0) }
    }
    
    func setUpConstraints(traits: UITraitCollection) {
        allViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let constraints: [NSLayoutConstraint]
        
        switch traits.verticalSizeClass {
        case .regular:
            constraints = [
                oneLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8.0),
                oneLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                twoLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
                twoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                threeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
                threeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                fourLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
                fourLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                oneButton.topAnchor.constraint(equalTo: oneLabel.bottomAnchor, constant: 8.0),
                oneButton.centerXAnchor.constraint(equalTo: oneLabel.centerXAnchor),
                twoButton.leadingAnchor.constraint(equalTo: twoLabel.trailingAnchor, constant: 8.0),
                twoButton.centerYAnchor.constraint(equalTo: twoLabel.centerYAnchor),
                threeButton.trailingAnchor.constraint(equalTo: threeLabel.leadingAnchor, constant: -8.0),
                threeButton.centerYAnchor.constraint(equalTo: threeLabel.centerYAnchor),
                fourButton.bottomAnchor.constraint(equalTo: fourLabel.topAnchor, constant: 8.0),
                fourButton.centerXAnchor.constraint(equalTo: fourLabel.centerXAnchor)
            ]
        case .compact:
            constraints = [
                oneLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8.0),
                oneLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
                twoLabel.topAnchor.constraint(equalTo: oneLabel.bottomAnchor, constant: 8.0),
                twoLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
                threeLabel.topAnchor.constraint(equalTo: twoLabel.bottomAnchor, constant: 8.0),
                threeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
                fourLabel.topAnchor.constraint(equalTo: threeLabel.bottomAnchor, constant: 8.0),
                fourLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
                
                oneButton.trailingAnchor.constraint(equalTo: oneLabel.leadingAnchor, constant: -8.0),
                oneButton.centerYAnchor.constraint(equalTo: oneLabel.centerYAnchor),
                twoButton.trailingAnchor.constraint(equalTo: twoLabel.leadingAnchor, constant: -8.0),
                twoButton.centerYAnchor.constraint(equalTo: twoLabel.centerYAnchor),
                threeButton.trailingAnchor.constraint(equalTo: threeLabel.leadingAnchor, constant: -8.0),
                threeButton.centerYAnchor.constraint(equalTo: threeLabel.centerYAnchor),
                fourButton.trailingAnchor.constraint(equalTo: fourLabel.leadingAnchor, constant: -8.0),
                fourButton.centerYAnchor.constraint(equalTo: fourLabel.centerYAnchor),
            ]
        case .unspecified:
            return
        @unknown default:
            return
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func applyStyles() {
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        [oneButton, twoButton, threeButton, fourButton].enumerated().forEach { (index, button) in
            button.setTitle("Toggle \(index + 1)", for: .normal)
            button.setTitleColor(.orange, for: .normal)
        }
        
        [oneLabel, twoLabel, threeLabel, fourLabel].enumerated().forEach { (index, label) in
            label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
            label.backgroundColor = .darkGray
            label.textAlignment = .center
            label.textColor = .white
            label.text = "Label \(index + 1)"
        }
    }
    
}
