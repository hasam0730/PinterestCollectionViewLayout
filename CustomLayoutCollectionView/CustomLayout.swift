//
//  CustomLayout.swift
//  CustomLayoutCollectionView
//
//  Created by Developer on 7/15/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

protocol CustomLayoutDelegate: class {
	func photosList(indexPath: IndexPath) -> Photo
}

class CustomLayout: UICollectionViewLayout {
	weak var delegate: CustomLayoutDelegate?
	
	let numberOfColumn = 3
	let itemPadding: CGFloat = 5
	
	var cacheAttributes = [UICollectionViewLayoutAttributes]()
	
	var contentHeight: CGFloat = 0.0
	var contentWidth: CGFloat {
		return collectionView!.bounds.width - collectionView!.contentInset.left * 2
	}
	
	var itemHeight: CGFloat = 0.0
	
	override func prepare() {
		super.prepare()
		let itemWidth: CGFloat = contentWidth/CGFloat(numberOfColumn)
		var xOffsetList = [CGFloat]()
		var yOffsetList = [CGFloat](repeating: 0.0, count: numberOfColumn)
		
		for column in 0..<numberOfColumn {
			xOffsetList.append(itemWidth*CGFloat(column))
		}
		
		var column = 0
		
		for item in 0..<collectionView!.numberOfItems(inSection: 0) {
			let indxpath = IndexPath(item: item, section: 0)
			let photoHeight = delegate!.photosList(indexPath: indxpath).image.size.height
			itemHeight = photoHeight + itemPadding * 2
			
			let itemFrame = CGRect(x: xOffsetList[column], y: yOffsetList[column], width: itemWidth, height: itemHeight)
			let itemFrameInset = itemFrame.insetBy(dx: itemPadding, dy: itemPadding)
			
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indxpath)
			attributes.frame = itemFrameInset
			
			cacheAttributes.append(attributes)
			
			yOffsetList[column] = yOffsetList[column] + itemHeight
			contentHeight = max(contentHeight, itemFrame.maxY)
			column = column < numberOfColumn-1 ? column + 1 : 0
			
			
		}
	}
	
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return cacheAttributes
	}
}
