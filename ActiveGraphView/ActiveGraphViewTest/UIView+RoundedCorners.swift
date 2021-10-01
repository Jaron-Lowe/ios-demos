//
//  UIView+RoundedCorners.swift
//
//  Created by Jaron Lowe.
//  Copyright (c) Jaron Lowe. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer();
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath;
        self.layer.mask = maskLayer;
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius;
        }
        set {
            self.layer.cornerRadius = newValue;
            self.layer.masksToBounds = (newValue > 0);
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth;
        }
        set {
            self.layer.borderWidth = newValue;
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor { return UIColor(cgColor: color); }
            return nil;
        }
        set {
            self.layer.borderColor = newValue?.cgColor;
        }
    }
    
}
