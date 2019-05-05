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
				
				if UIDevice.current.userInterfaceIdiom == .pad {
					vc.iPadDismissHandler 		= { self.reloadView() }
					vc.modalTransitionStyle 	= .coverVertical
					vc.modalPresentationStyle 	= .formSheet
					present(vc, animated: true, completion: nil)
				} else if UIDevice.current.userInterfaceIdiom == . phone {
					navigationController?.pushViewController(vc, animated: true)
				}
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
		
		deleteAlert.alertTitle 			= NSLocalizedString("counterMenudeleteAction_title", comment: "Title: Delete")
		deleteAlert.alertDescription 	= NSLocalizedString("counterMenudeleteAction_description", comment: "Description: Are you sure you want to delete this counter?")
		deleteAlert.alertOkButtonText 	= NSLocalizedString("counterMenudeleteAction_button", comment: "Button: delete")
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
		resetToAlert.definesPresentationContext 				= true
		resetToAlert.modalPresentationStyle 					= UIModalPresentationStyle.overCurrentContext
		resetToAlert.modalTransitionStyle 						= UIModalTransitionStyle.crossDissolve
		resetToAlert.delegate 									= self
		
		resetToAlert.alertTitle 		= NSLocalizedString("counterMenuResetAction_title", comment: "Title: reset counter")
		resetToAlert.alertDescription 	= NSLocalizedString("counterMenuResetAction_description", comment: "Description: write a new value for the counter")
		resetToAlert.alertOkButtonText 	= NSLocalizedString("counterMenuResetAction_button", comment: "Button: reset")
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
	
}
