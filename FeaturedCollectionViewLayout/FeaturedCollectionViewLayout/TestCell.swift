//
//  TestCell.swift
//  FeaturedCollectionViewLayout
//
//  Created by Jaron Lowe on 3/5/21.
//

import UIKit

final class TestCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var indexLabel: UILabel!
    
    static let identifier = "testCell"
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        DispatchQueue.main.async {
            guard let attr = layoutAttributes as? FeaturedCollectionViewLayoutAttributes else { return }
            let scale = 0.25 + (0.75 * attr.delta)
            self.indexLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func configure(color: UIColor, index: Int) {
        backView.backgroundColor = color
        indexLabel.text = "\(index)"
    }
}
