//
//  CustomLayout.swift
//  Jasy
//
//  Created by user on 1/4/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

//from https://www.raywenderlich.com/164608/uicollectionview-custom-layout-tutorial-pinterest-2
class CustomLayout: UICollectionViewLayout {
    
    fileprivate var numberOfColumns = 3
    fileprivate var cellPadding: CGFloat = 6
    
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        super.prepare()
        
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffSet: [CGFloat] = []
        
        for column in 0..<numberOfColumns {
            xOffSet.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffSet = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeith = columnWidth
            let height = photoHeith
            
            let frame = CGRect(x: xOffSet[column], y: yOffSet[column], width: columnWidth, height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffSet[column] = yOffSet[column] + height
            
            column = column < (numberOfColumns - 1) ? column + 1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        cache.removeAll()
    }

}
