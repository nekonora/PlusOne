//
//  UICollectionView+Additions.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


extension RootViewController: CounterCellDelegate {
	
	
	@objc func didTapCustomize(id: UUID) {
		if let counter = countersCollection.dataSource.countersList.filter( { $0.id == id } ).first {
			if let vc = storyboard?.instantiateViewController(withIdentifier: "CounterDetailVC") as? CounterDetailVC {
				vc.counter 		= counter
				vc.dataSource 	= countersCollection.dataSource
				navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	
	@objc func didTapDelete(id: UUID) {
		if let counter = countersCollection.dataSource.countersList.filter( { $0.id == id } ).first {
			let alert = UIAlertController(
				title: "Delete the counter?",
				message: "Do you really want to delete the counter \"\(counter.name ?? "")\"?",
				preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
				let index = self.countersCollection.dataSource.countersList.firstIndex{$0.id == id}
				self.countersCollection.dataSource.countersList.remove(at: index!)
				self.countersCollection.dataSource.saveToDefaults()
				self.reloadView()
				self.countersCollection.collectionView.reloadData()
				
			}))
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			
			self.present(alert, animated: true)
		}
	}
	
	
	@objc func didTapResetTo(id: UUID) {
		//
	}
	
	
	@objc func didTapStepper(id: UUID, newValue: Float) {
		
		if let tempCounter = countersCollection.dataSource.countersList.filter( { $0.id == id } ).first {
			let index = countersCollection.dataSource.countersList.firstIndex{$0.id == id}
			tempCounter.value = newValue
			countersCollection.dataSource.countersList.remove(at: index!)
			countersCollection.dataSource.countersList.insert(tempCounter, at: index!)
			
			countersCollection.dataSource.saveToDefaults()
		}
		
		countersCollection.collectionView.reloadData()
	}
	
	
	@objc func didTapEdit(id: UUID) {
		if let counter = countersCollection.dataSource.countersList.filter( { $0.id == id } ).first {
			if let vc = storyboard?.instantiateViewController(withIdentifier: "CounterDetailVC") as? CounterDetailVC {
				vc.counter 		= counter
				vc.dataSource 	= countersCollection.dataSource
				navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	
}
