//
//  UICollectionView+Additions.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


extension UICollectionViewController: CounterCellDelegate {
	
	
	@objc func didTapStepper(dataSource: CountersDataSource, id: UUID, newValue: Float) {
		
		if let tempCounter = dataSource.countersList.filter( { $0.id == id } ).first {
			let index = dataSource.countersList.index{$0.id == id}
			tempCounter.value = newValue
			dataSource.countersList.remove(at: index!)
			dataSource.countersList.insert(tempCounter, at: index!)
			
			dataSource.saveToDefaults()
		}
		
		collectionView.reloadData()
		
	}
	
	
	@objc func didTapEdit(dataSource: CountersDataSource, id: UUID) {
		if let counter = dataSource.countersList.filter( { $0.id == id } ).first {
			if let vc = storyboard?.instantiateViewController(withIdentifier: "CounterDetailVC") as? CounterDetailVC {
				vc.counter 		= counter
				vc.dataSource 	= dataSource
				navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	
}
