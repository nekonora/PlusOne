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
		let screenWidth 		= UIScreen.main.bounds.width
		let cellWidth: CGFloat 	= 176.0
		
		let maxNumberOfCellsPerRow = Int((screenWidth / cellWidth).rounded())
		
		let horizontalWhiteSpace = screenWidth - ( CGFloat(maxNumberOfCellsPerRow) * cellWidth )
		let sideInset = (horizontalWhiteSpace / CGFloat( maxNumberOfCellsPerRow + 4 )).rounded()
		
		
		let _flowLayout 					= UICollectionViewFlowLayout()
		_flowLayout.itemSize 				= CGSize(width: cellWidth, height: 186)
		_flowLayout.sectionInset 			= UIEdgeInsets(top: 10, left: sideInset * 2, bottom: 20, right: sideInset * 2)
		_flowLayout.scrollDirection 		= UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = sideInset
		_flowLayout.minimumLineSpacing		= sideInset * 2
		_flowLayout.headerReferenceSize 	= CGSize(width: 100, height: 50)
		return _flowLayout
	}
	
	static var big: UICollectionViewFlowLayout {
		let screenWidth 		= UIScreen.main.bounds.width
		let cellWidth: CGFloat 	= 300
		
		let maxNumberOfCellsPerRow = Int((screenWidth / cellWidth).rounded())
		
		let horizontalWhiteSpace = screenWidth - ( CGFloat(maxNumberOfCellsPerRow) * cellWidth )
		let sideInset = (horizontalWhiteSpace / CGFloat( maxNumberOfCellsPerRow + 4 )).rounded()
		
		let _flowLayout 					= UICollectionViewFlowLayout()
		_flowLayout.itemSize 				= CGSize(width: cellWidth, height: 186)
		_flowLayout.sectionInset 			= UIEdgeInsets(top: 10, left: sideInset * 2, bottom: 20, right: sideInset * 2)
		_flowLayout.scrollDirection 		= UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = sideInset
		_flowLayout.minimumLineSpacing		= sideInset * 2
		_flowLayout.headerReferenceSize 	= CGSize(width: 100, height: 50)
		return _flowLayout
	}
	
	
}
