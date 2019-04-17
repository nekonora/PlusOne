//
//  CustomCollectionViewLayout.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 17/04/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


enum CountersLayoutType {
	
	
	// MARK: - Properties
	static var small: UICollectionViewFlowLayout {
		let _flowLayout 					= UICollectionViewFlowLayout()
		_flowLayout.itemSize 				= CGSize(width: 176, height: 186)
		_flowLayout.sectionInset 			= UIEdgeInsets(top: 10, left: 5, bottom: 20, right: 5)
		_flowLayout.scrollDirection 		= UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = 10.0
		_flowLayout.minimumLineSpacing		= 15.0
		_flowLayout.headerReferenceSize 	= CGSize(width: 100, height: 50)
		return _flowLayout
	}
	
	static var big: UICollectionViewFlowLayout {
		let _flowLayout 					= UICollectionViewFlowLayout()
		_flowLayout.itemSize 				= CGSize(width: 300, height: 186)
		_flowLayout.sectionInset 			= UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
		_flowLayout.scrollDirection 		= UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = 10.0
		_flowLayout.minimumLineSpacing		= 15.0
		_flowLayout.headerReferenceSize 	= CGSize(width: 100, height: 50)
		return _flowLayout
	}
	
	
}
