//
//  PersonCell.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/21/21.
//

import UIKit
import Nuke

final class PersonCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet private var pictureImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!
    
    static let identifier = "Cell"
    
    // MARK: Action Methods
    
    func configure(model: Person) {
        if let url = URL(string: model.imageUrl) {
            Nuke.loadImage(
                with: url,
                options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                into: pictureImageView
            )
        } else { pictureImageView.image = nil }
        
        titleLabel.text = model.fullName
        detailLabel.text = "\(model.gender.title) (\(model.age))"
    }
    
}
