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
	
	func didTapDelete(id: UUID) {
		let storyboard = UIStoryboard(name: "ThemableAlertVC", bundle: nil)
		let deleteAlert = storyboard.instantiateViewController(withIdentifier: "ThemableAlertVC") as! ThemableAlertVC
		deleteAlert.providesPresentationContextTransitionStyle 	= true
		deleteAlert.definesPresentationContext 					= true
		deleteAlert.modalPresentationStyle 						= UIModalPresentationStyle.overCurrentContext
		deleteAlert.modalTransitionStyle 						= UIModalTransitionStyle.crossDissolve
		deleteAlert.delegate = self
		
		deleteAlert.alertTitle 			= "Delete Counter"
		deleteAlert.alertDescription 	= "Are you sure you want to delete this counter?"
		deleteAlert.alertOkButtonText 	= "Delete"
		deleteAlert.alertAction			= .deleteCounter
		deleteAlert.alertCounterID		= id
		
		self.present(deleteAlert, animated: true, completion: nil)
	}
	
	@objc func deleteCounter(id: UUID) {
		if countersCollection.dataSource.countersList.filter( { $0.id == id } ).first != nil {
			let index = self.countersCollection.dataSource.countersList.firstIndex{$0.id == id}
			self.countersCollection.dataSource.countersList.remove(at: index!)
			self.countersCollection.dataSource.saveToDefaults()
			self.reloadView()
			self.countersCollection.collectionView.reloadData()
		}
	}
	
	func didTapResetTo(id: UUID) {
		let storyboard = UIStoryboard(name: "ThemableAlertVC", bundle: nil)
		let resetToAlert = storyboard.instantiateViewController(withIdentifier: "ThemableAlertVC") as! ThemableAlertVC
		resetToAlert.providesPresentationContextTransitionStyle = true
		resetToAlert.definesPresentationContext = true
		resetToAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
		resetToAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
		resetToAlert.delegate = self
		
		resetToAlert.alertTitle 		= "Reset Counter"
		resetToAlert.alertDescription 	= "Write a new value for the counter"
		resetToAlert.alertOkButtonText 	= "Reset"
		resetToAlert.alertKeyboardType 	= .decimalPad
		resetToAlert.alertPlaceholder 	= "0"
		resetToAlert.alertAction		= .resetCounter
		resetToAlert.alertCounterID		= id
		
		self.present(resetToAlert, animated: true, completion: nil)
	}
	
	@objc func resetCounter(id: UUID, value: Float) {
		if let tempCounter = countersCollection.dataSource.countersList.filter( { $0.id == id } ).first {
			let index = countersCollection.dataSource.countersList.firstIndex{$0.id == id}
			tempCounter.value = value
			countersCollection.dataSource.countersList.remove(at: index!)
			countersCollection.dataSource.countersList.insert(tempCounter, at: index!)
			
			countersCollection.dataSource.saveToDefaults()
		}
		countersCollection.collectionView.reloadData()
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
