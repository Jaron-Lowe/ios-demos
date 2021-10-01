//
//  ActiveGraphView.swift
//
//  Created by Jaron Lowe on 8/3/21.
//

import UIKit

public final class ActiveGraphView: UIStackView {
    
    // MARK: - Properties
    
    private static let paddingRatio: CGFloat = (1.0 / 4.0)
    private var currentConfiguration: Configuration?
    private var proportionConstraints: [NSLayoutConstraint] = []
    
    /// The index of the currently active bar.
    public var activeIndex: Int? {
        didSet {
            activeIndexChanged()
        }
    }
    
    // MARK: - Lifecycle
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// Initializes an instance with a specific configuration.
    /// - Parameter configuration: A configuration object used to configure the object upon initialization.
    public init(configuration: Configuration) {
        super.init(frame: CGRect.zero)
        configure(configuration: configuration)
    }
    
    /// Updates the configuration of the view.
    /// - Parameter configuration: A object with configuration details for the view.
    public func configure(configuration: Configuration) {
        currentConfiguration = configuration
        
        axis = configuration.axis
        distribution = .fillProportionally
        
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
        for color in configuration.colors {
            let barView = BarView(configuration: configuration, color: color)
            addArrangedSubview(barView)
        }
        
        activeIndexChanged()
    }
    
}

// MARK: - Private Methods

private extension ActiveGraphView {
    
    func activeIndexChanged() {
        if currentConfiguration?.shouldAnimateChanges == true {
            UIView.animate(withDuration: 0.25) {
                self.refreshView()
            }
        } else {
            refreshView()
        }
    }
    
    func refreshView() {
        for (viewIndex, view) in arrangedSubviews.enumerated() {
            let isActiveView = viewIndex == activeIndex
            view.alpha = isActiveView ? 1.0 : currentConfiguration?.inactiveAlpha ?? 0.5
            if let barView = view as? BarView, let stackView = barView.subviews.first as? UIStackView {
                barView.weight = isActiveView ? currentConfiguration?.growthWeight ?? 1.0 : 1.0
                setNeedsLayout()
                stackView.arrangedSubviews.first?.isHidden = isActiveView
            }
            layoutIfNeeded()
        }
    }
    
}

// MARK: - Configuration

public extension ActiveGraphView {
    
    struct Configuration {
        
        /// The colors to associate with the graph.
        public let colors: [UIColor]
        
        /// The layout axis of the graph.
        public let axis: NSLayoutConstraint.Axis
        
        /// The spacing between each bar in the graph.
        public let spacing: CGFloat
        
        /// The growth weight to apply to the active bar across the graphs axis.
        public let growthWeight: CGFloat
        
        /// The alpha of a bar in an inactive state.
        public let inactiveAlpha: CGFloat
        
        /// A flag indicating whether changes to the active bar should be animated.
        public let shouldAnimateChanges: Bool
        
        public init(colors: [UIColor], axis: NSLayoutConstraint.Axis, spacing: CGFloat, growthWeight: CGFloat, inactiveAlpha: CGFloat, shouldAnimateChanges: Bool) {
            self.colors = colors
            self.axis = axis
            self.spacing = spacing
            self.growthWeight = growthWeight
            self.inactiveAlpha = inactiveAlpha
            self.shouldAnimateChanges = shouldAnimateChanges
        }
        
    }
    
}

private extension ActiveGraphView {
    
    final class BarView: UIView {
        
        // MARK: - Properties
        
        fileprivate var weight: CGFloat = 1.0 {
            didSet {
                invalidateIntrinsicContentSize()
            }
        }
        private var axis: NSLayoutConstraint.Axis = .horizontal
        override var intrinsicContentSize: CGSize {
            if axis == .horizontal {
                return CGSize(width: weight, height: 1.0)
            } else {
                return CGSize(width: 1.0, height: weight)
            }
        }
        
        // MARK: - Lifecycle
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        init(configuration: Configuration, color: UIColor) {
            super.init(frame: CGRect.zero)
            
            axis = configuration.axis
            
            let barStackView = UIStackView()
            addSubview(barStackView)
            
            let horizontalSpacing: CGFloat = axis == .horizontal ? -configuration.spacing : 0.0
            let verticalSpacing: CGFloat = axis == .vertical ? -configuration.spacing : 0.0
            barStackView.translatesAutoresizingMaskIntoConstraints = false
            var constraintsToActivate: [NSLayoutConstraint] = [
                barStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                barStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: horizontalSpacing),
                barStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                barStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: verticalSpacing)
            ]
            barStackView.axis = configuration.axis == .horizontal ? .vertical : .horizontal
            
            let spacerView = UIView()
            let colorView = UIView()
            barStackView.addArrangedSubview(spacerView)
            barStackView.addArrangedSubview(colorView)
            
            spacerView.backgroundColor = .clear
            if barStackView.axis == .horizontal {
                constraintsToActivate.append(spacerView.widthAnchor.constraint(equalTo: barStackView.widthAnchor, multiplier: ActiveGraphView.paddingRatio))
            } else {
                constraintsToActivate.append(spacerView.heightAnchor.constraint(equalTo: barStackView.heightAnchor, multiplier: ActiveGraphView.paddingRatio))
            }
            NSLayoutConstraint.activate(constraintsToActivate)

            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 2.0
        }
    }
    
}
