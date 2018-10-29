//
//  CollectionViewLayout.swift
//  CustomLayoutCollectionView
//
//  Created by Developer on 7/14/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
	func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
	
	weak var delegate: PinterestLayoutDelegate!
	
	fileprivate var numberOfColumns = 3
	fileprivate var cellPadding: CGFloat = 5
	
	fileprivate var cache = [UICollectionViewLayoutAttributes]()
	
	fileprivate var contentHeight: CGFloat = 0
	fileprivate var contentWidth: CGFloat {
		guard let collectionView = collectionView else {
			return 0
		}
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}
	
	override func prepare() {
		guard cache.isEmpty, let collectionView = collectionView else { return }
		
		let columnWidth = contentWidth/CGFloat(numberOfColumns)
		var xOffset = [CGFloat]()
		var yOffset = [CGFloat](repeating: 0.0, count: numberOfColumns)
		
		for column in 0..<numberOfColumns {
			xOffset.append(CGFloat(column)*columnWidth)
		}
		
		var column = 0
		for item in 0..<collectionView.numberOfItems(inSection: 0) {
			let indexpath = IndexPath(item: item, section: 0)
			
			let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexpath)
			let heightItem = photoHeight + (cellPadding * 2)
			let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: heightItem)
			
			let frameInset = frame.insetBy(dx: cellPadding, dy: cellPadding)
			
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexpath)
			attributes.frame = frameInset
			
			cache.append(attributes)
			
			contentHeight = max(contentHeight, frame.maxY)
			
			yOffset[column] = yOffset[column] + heightItem
			
			column = column < numberOfColumns-1 ? column + 1 : 0
		}
	}
	
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
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
}


















