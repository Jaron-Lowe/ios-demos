//
//  FixedGridCollectionViewLayout.swift
//  Echelon Fit
//
//  Created by Jaron Lowe on 3/8/21.
//

import UIKit

class FixedGridCollectionViewLayout: UICollectionViewLayout {

    // ===========================================================================
    // MARK: Properties
    // ===========================================================================
    
    @IBInspectable public var columnCount: Int = 3 { didSet { invalidateLayout() }}
    @IBInspectable public var rowHeight: CGFloat = 45.0 { didSet { invalidateLayout() }}
    @IBInspectable public var itemSpacing: CGFloat = 32.0 { didSet { invalidateLayout() }}
    @IBInspectable public var lineSpacing: CGFloat = 16.0 { didSet { invalidateLayout() }}
    @IBInspectable public var topInset: CGFloat = 0.0 { didSet { invalidateLayout() }}
    @IBInspectable public var bottomInset: CGFloat = 0.0 { didSet { invalidateLayout() }}
    @IBInspectable public var leftInset: CGFloat = 0.0 { didSet { invalidateLayout() }}
    @IBInspectable public var rightInset: CGFloat = 0.0 { didSet { invalidateLayout() }}
    @IBInspectable public var shouldShowItemSeparators: Bool = true { didSet { invalidateLayout() }}
    @IBInspectable public var itemSeparatorRatio: CGFloat = 0.6 { didSet { invalidateLayout() }}
    @IBInspectable public var shouldShowLineSeparators: Bool = true { didSet { invalidateLayout() }}
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var width: CGFloat { return collectionView!.bounds.width }
    private var height: CGFloat { return collectionView!.bounds.height }
    private var numberOfItems: Int { return collectionView!.numberOfItems(inSection: 0) }
    private var horizontalInset: CGFloat { return leftInset + rightInset }
    private var verticalInset: CGFloat { return topInset + bottomInset }
    private var cellWidth: CGFloat { return ((width - horizontalInset - (itemSpacing * CGFloat(columnCount - 1))) / CGFloat(columnCount)) }
    private var rowCount: Int { return Int(ceil(Double(numberOfItems) / Double(columnCount))) }
    private var itemSeparatorOffset: CGFloat {
        return ((rowHeight - verticalInset) - ((rowHeight - verticalInset) * itemSeparatorRatio)) / 2
    }
    
    private var isDecorationRegistered: Bool = false
    

    // ===========================================================================
    // MARK: Layout Overrides
    // ===========================================================================
    
    override var collectionViewContentSize: CGSize {
        let totalHeight = (rowHeight * CGFloat(rowCount)) + (lineSpacing * CGFloat(rowCount - 1))
        return CGSize(
            width: width,
            height: totalHeight + verticalInset
        )
    }
    
    override func prepare() {
        super.prepare()
        
        guard (cache.isEmpty == true), (numberOfItems > 0) else { return }
        
        if isDecorationRegistered == false {
            register(GridLineDecorationView.self, forDecorationViewOfKind: GridLineDecorationView.identifier)
        }
        
        let deviceScale = UIScreen.main.scale
        
        // Calculate Cell Attributes
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let cellAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let column = item % columnCount
            let row = Int(CGFloat(item) / CGFloat(columnCount))
            cellAttribute.frame = CGRect(
                x: leftInset + CGFloat(column) * (cellWidth + itemSpacing),
                y: topInset + CGFloat(row) * (rowHeight + lineSpacing),
                width: cellWidth,
                height: rowHeight
            )
            cache.append(cellAttribute)
            
            // Calculate Item Separators
            if shouldShowItemSeparators == true && column < columnCount {
                let lineAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: GridLineDecorationView.identifier, with: indexPath)
                
                lineAttribute.frame = CGRect(
                    x: leftInset + (CGFloat(column) * (cellWidth + itemSpacing)) - (itemSpacing / 2),
                    y: topInset + cellAttribute.frame.minY + itemSeparatorOffset,
                    width: 1.0/deviceScale,
                    height: (rowHeight - verticalInset) * itemSeparatorRatio
                )
                cache.append(lineAttribute)
            }
        }
        
        // Calculate Line Separators
        if shouldShowLineSeparators == true {
            
            for row in 0..<rowCount - 1 {
                let indexPath = IndexPath(item: (row * columnCount), section: 0)
                let attribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: GridLineDecorationView.identifier, with: indexPath)
                
                attribute.frame = CGRect(
                    x: leftInset,
                    y: topInset + (CGFloat(row + 1) * rowHeight) + (CGFloat(row + 1) * lineSpacing) - (lineSpacing / 2),
                    width: width - horizontalInset,
                    height: 1.0/deviceScale
                )
                cache.append(attribute)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) { layoutAttributes.append(attributes) }
        }
        return layoutAttributes
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache = []
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}


final class GridLineDecorationView: UICollectionReusableView {
    
    static let identifier = "line"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
