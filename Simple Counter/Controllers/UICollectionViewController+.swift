//
//  UICollectionView+Additions.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


extension UICollectionViewController: CounterCellDelegate {
	
	
	@objc func didTapCustomize(dataSource: CountersDataSource, id: UUID) {
		if let counter = dataSource.countersList.filter( { $0.id == id } ).first {
			if let vc = storyboard?.instantiateViewController(withIdentifier: "CounterDetailVC") as? CounterDetailVC {
				vc.counter 		= counter
				vc.dataSource 	= dataSource
				navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	
	@objc func didTapDelete(dataSource: CountersDataSource, id: UUID) {
		if let counter = dataSource.countersList.filter( { $0.id == id } ).first {
			let alert = UIAlertController(
				title: "Delete the counter?",
				message: "Do you really want to delete the counter \"\(counter.name ?? "")\"?",
				preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
				let index = dataSource.countersList.index{$0.id == id}
				dataSource.countersList.remove(at: index!)
				dataSource.saveToDefaults()
				self.collectionView.reloadData()
			}))
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			
			self.present(alert, animated: true)
		}
	}
	
	
	@objc func didTapResetTo(dataSource: CountersDataSource, id: UUID) {
		//
	}
	
	
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
