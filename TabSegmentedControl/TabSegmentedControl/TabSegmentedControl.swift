//
//  TabSegmentedControl.swift
//  
//
//  Created by Jaron Lowe.
//

import UIKit

public final class TabSegmentedControl: UISegmentedControl {
    
    // MARK: Properties
    
    /// The text color for a segment in the normal state.
    public var normalTextColor: UIColor = .darkGray {
        didSet {
            setTitleTextAttributes([.foregroundColor: normalTextColor], for: .normal)
        }
    }
    
    /// The text color for a segment in the selected state.
    public var selectedTextColor: UIColor = .black {
        didSet {
            setTitleTextAttributes([.foregroundColor: selectedTextColor], for: .selected)
        }
    }
    
    /// The text color for a segment in the disabled state.
    public var disabledTextColor: UIColor = .lightGray {
        didSet {
            setTitleTextAttributes([.foregroundColor: disabledTextColor], for: .disabled)
        }
    }
    
    /// The color of the selection indicator.
    public var selectionIndicatorColor: UIColor = .blue {
        didSet {
            selectionIndicatorView.backgroundColor = selectionIndicatorColor
        }
    }
    
    /// The color of the selection indicator tray.
    public var selectionIndicatorTrayColor: UIColor = .lightGray.withAlphaComponent(0.8) {
        didSet {
            selectionIndicatorViewTray.backgroundColor = selectionIndicatorTrayColor
        }
    }
    
    /// The thickness of the selection indicator and its tray.
    public var selectionIndicatorThickness: CGFloat = 2.0 {
        didSet {
            selectionIndicatorViewTray.layer.cornerRadius = (selectionIndicatorThickness / 2.0)
            selectionIndicatorView.layer.cornerRadius = (selectionIndicatorThickness / 2.0)
            setNeedsLayout()
        }
    }
    
    private lazy var selectionIndicatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: bounds.height, width: 0, height: selectionIndicatorThickness))
        view.backgroundColor = selectionIndicatorColor
        return view
    }()
    
    private lazy var selectionIndicatorViewTray: UIView = {
        let view = UIView()
        view.backgroundColor = selectionIndicatorTrayColor
        return view
    }()
    
    // MARK: UIView
    
    override init(items: [Any]?) {
        super.init(items: items)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 0
        updateSelectionIndicatorTrayFrame()
        updateSelectionIndicatorFrame()
    }
    
    
}

// MARK: - Private Methods

private extension TabSegmentedControl {
    
    func configure() {
        addSubview(selectionIndicatorViewTray)
        addSubview(selectionIndicatorView)
        setNeedsLayout()
        
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = .clear
        }
        backgroundColor = .clear
        let tintImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
        setBackgroundImage(tintImage, for: .normal, barMetrics: .default)
        setDividerImage(tintImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    func updateSelectionIndicatorTrayFrame() {
        selectionIndicatorViewTray.frame = CGRect(
            x: 0,
            y: bounds.height - selectionIndicatorThickness,
            width: bounds.width,
            height: selectionIndicatorThickness
        )
    }
    
    func updateSelectionIndicatorFrame() {
        let width = (numberOfSegments != 0) ? bounds.width / CGFloat(numberOfSegments) : CGFloat(0.0)
        let height = selectionIndicatorThickness
        let x = CGFloat(selectedSegmentIndex * Int(width))
        let y = bounds.height - selectionIndicatorThickness
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.selectionIndicatorView.frame = CGRect(x: x, y: y, width: width, height: height)
            },
            completion: nil
        )
        
    }
    
    @objc func valueChanged() {
        updateSelectionIndicatorFrame()
    }
    
}


// MARK: - UIImage

fileprivate extension UIImage {
    
    /// Creates an image of a given size from a specified color.
    /// - Parameters:
    ///   - color: The color from which to generate an image.
    ///   - size: The size of the image to generate.
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}
