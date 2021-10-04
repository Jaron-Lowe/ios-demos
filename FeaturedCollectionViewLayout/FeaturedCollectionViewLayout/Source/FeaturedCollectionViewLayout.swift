//
//  FeaturedCollectionViewLayout.swift
//
//  Created by Jaron Lowe on 3/5/21.
//

import UIKit

class FeaturedCollectionViewLayout: UICollectionViewLayout {
    
    // ===========================================================================
    // MARK: Properties
    // ===========================================================================
    
    private var cache: [FeaturedCollectionViewLayoutAttributes] = []
    private var standardWidth: CGFloat = 180
    private var featuredWidth: CGFloat { return min(width * 0.95, 425) }
    private var width: CGFloat { return collectionView!.bounds.width }
    private var height: CGFloat { return collectionView!.bounds.height }
    private var numberOfItems: Int { return collectionView!.numberOfItems(inSection: 0) }
    
    
    // ===========================================================================
    // MARK: Layout Overrides
    // ===========================================================================
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (CGFloat(numberOfItems) * featuredWidth) + (collectionView!.frame.width - featuredWidth), height: height)
    }
    
    override func prepare() {
        super.prepare()
        
        cache.removeAll(keepingCapacity: false)
        
        var x: CGFloat = 0.0
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = FeaturedCollectionViewLayoutAttributes(forCellWith: indexPath)
            
            var width = featuredWidth
            var currentGrowth: CGFloat = 0.0
            var delta: CGFloat = 0.0
            let offsetX = collectionView!.contentOffset.x
            let maxGrowth = featuredWidth - standardWidth
            
            // Prevent Reshrinking below relative zero offset
            if (offsetX <= x) {
                delta = max(min(abs(max(offsetX, 0) - (CGFloat(item) * featuredWidth)) / featuredWidth, 1.0), 0)
                currentGrowth = (maxGrowth * delta)
                width = width - currentGrowth
            }
            
            let frame = CGRect(x: x, y: 0, width: width, height: height)
            attributes.frame = frame
            attributes.delta = 1 - delta
            attributes.featuredWidth = featuredWidth
            cache.append(attributes)
            
            x = frame.maxX
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if (attributes.frame.intersects(rect)) { layoutAttributes.append(attributes) }
        }
        return layoutAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var delta = (proposedContentOffset.x / featuredWidth)
        if (velocity.x > 0.005) { delta = ceil(delta) }
        if (velocity.x < -0.005) { delta = floor(delta) }
        else if (abs(velocity.x) <= 0.005) { delta = round(delta) }
        let snapX = delta * featuredWidth
        return CGPoint(x: snapX, y: 0.0)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    // ===========================================================================
    // MARK: Helper Methods
    // ===========================================================================
    
    func featuredCellIndex() -> IndexPath {
        let delta = round(collectionView!.contentOffset.x / featuredWidth)
        return IndexPath(item: Int(delta), section: 0)
    }
    
    // Used to feature the correct cell after orientation change
    func scrollToIndex(indexPath: IndexPath, animated: Bool = true) {
        let newOffset = CGPoint(x: CGFloat(indexPath.item) * featuredWidth, y: 0)
        collectionView!.setContentOffset(newOffset, animated: true)
    }
    
    
}


class FeaturedCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes {
    
    // ===========================================================================
    // MARK: Properties
    // ===========================================================================
    
    var delta: CGFloat = 1.0
    var featuredWidth: CGFloat = 200.0
    
    
    // ===========================================================================
    // MARK: - Life Cycle
    // ===========================================================================
    
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? FeaturedCollectionViewLayoutAttributes else {
            return super.copy(with: zone)
        }
        
        copiedAttributes.delta = delta
        copiedAttributes.featuredWidth = featuredWidth
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? FeaturedCollectionViewLayoutAttributes else { return false }
        
        if (otherAttributes.delta != delta || otherAttributes.featuredWidth != featuredWidth) { return false }
        return super.isEqual(object)
    }
    
}

