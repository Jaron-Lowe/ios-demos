//
// SelfSizedCollectionView.swift
//
// Created by Jaron Lowe on 4/21/20.
//

import UIKit

/// A collection view subclass that generates its intrinsic size from its content. Useful for dynamic collection views with no scrolling.
class SelfSizedCollectionView: UICollectionView {

    // MARK: - Properties

    /// A minimum height for which the collection view should not intrinsically be smaller than.
    @IBInspectable var minimumHeight: CGFloat = 0.0

    // MARK: - UIView

    override var contentSize: CGSize {
        didSet {
            if oldValue != contentSize {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: contentSize.width,
            height: max(contentSize.height, minimumHeight)
        )
    }

}
