//
//  ViewController.swift
//  CustomLayoutCollectionView
//
//  Created by Developer on 7/14/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class PhotoStreamViewController: UICollectionViewController {
	var photos = Photo.allPhotos()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		if let layout = collectionView?.collectionViewLayout as? CustomLayout {
			layout.delegate = self
		}
//		
		collectionView?.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension PhotoStreamViewController {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
		if let annotateCell = cell as? AnnotatedPhotoCell { 
			annotateCell.photo = photos[indexPath.item]
		}
		return cell
	}
}

extension PhotoStreamViewController: PinterestLayoutDelegate, CustomLayoutDelegate {
	func photosList(indexPath: IndexPath) -> Photo {
		return photos[indexPath.item]
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
		return photos[indexPath.item].image.size.height
	}
}

