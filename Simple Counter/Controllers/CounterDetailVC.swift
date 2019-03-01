//
//  CounterDetailVC.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 27/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


class CounterDetailVC: UIViewController, UITextFieldDelegate {
	
	
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var textFieldsUI: [UITextField]!
	
	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var stepsTextField: UITextField!
	@IBOutlet var unitTextField: UITextField!
	@IBOutlet var completionTextField: UITextField!
	
	@IBAction func deleteTapped(_ sender: Any) {
		deleteCounter(dataSource: dataSource)
	}
	
	
	var counter		: CounterStruct!
	var dataSource	: CountersDataSource!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		setupTextFields()
		setupSaveButton()
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		title = counter.name!
    }
	
	
	fileprivate func setupSaveButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Save",
			style: .plain,
			target: self,
			action: #selector(saveTapped))
	}
	
	
	fileprivate func setupTextFields() {
		for textField in textFieldsUI {

			textField.layer.cornerRadius =  15
			let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
			textField.leftView = leftView
			textField.leftViewMode = .always

			textField.layer.borderWidth = 1.0
			textField.layer.borderColor = UIColor(named: "greenPastel")!.cgColor
			textField.keyboardAppearance = UIKeyboardAppearance.dark
			textField.delegate = self
		}
		
		
		nameTextField.text 			= String(counter.name)
		stepsTextField.text 		= String(counter.steps)
		unitTextField.text 			= counter.unit
		completionTextField.text 	= String(counter.completionValue)
	}
	
	
	@objc fileprivate func saveTapped() {
		
		

//		let stepsNumber 		= numberFormatter.number(from: (stepsTextField.text ?? "1"))
//		let stepsFloat		 	= stepsNumber!.floatValue
//
//		let completionNumber 	= numberFormatter.number(from: completionTextField.text ?? "0")
//		let completionFloat	 	= completionNumber!.floatValue
		
//		let stepsFloat = (stepsTextField.text! as NSString).floatValue
//		let completionFloat = (completionTextField.text! as NSString).floatValue
		
	
		let newName 			= nameTextField.text ?? ""
		let newUnit 			= unitTextField.text ?? ""
		let newSteps			: Float
		let newCompletion		: Float
		
		if let stepsString = stepsTextField.text {
			newSteps = stepsString.floatValue
		} else {
			newSteps = 1.0
		}
		
		if let completionString = completionTextField.text {
			newCompletion = completionString.floatValue
		} else {
			newCompletion = 0.0
		}
		
		updateCounter(dataSource			: dataSource,
					  id					: counter.id,
					  newName				: newName,
					  newSteps				: newSteps,
					  newUnit				: newUnit,
					  newCompletionValue	: newCompletion)
		
		navigationController?.popViewController(animated: true)
	}
	
	
	@objc func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!

		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

		if notification.name == UIResponder.keyboardWillHideNotification {
			scrollView.contentInset = UIEdgeInsets.zero
		} else {
			scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
		}

		scrollView.scrollIndicatorInsets = scrollView.contentInset
	}
	
	
	fileprivate func updateCounter(dataSource: CountersDataSource,
					   id					: UUID,
					   newName				: String,
					   newSteps				: Float,
					   newUnit				: String,
					   newCompletionValue	: Float ) {
		
		if var tempCounter = dataSource.countersList.filter( { $0.id == id } ).first {
			let index = dataSource.countersList.index{$0.id == id}
			
			tempCounter.name 			= newName
			tempCounter.steps 			= newSteps
			tempCounter.unit 			= newUnit
			tempCounter.completionValue = newCompletionValue
			
			dataSource.countersList.remove(at: index!)
			dataSource.countersList.insert(tempCounter, at: index!)
			
			dataSource.saveToDefaults()
		}
	}
	
	
	@objc fileprivate func deleteCounter(dataSource: CountersDataSource) {
		let alert = UIAlertController(
			title: "Delete the counter?",
			message: "Do you really want to delete the counter \"\(counter.name ?? "")\"?",
			preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
			let index = dataSource.countersList.index{$0.name == self.counter.name}
			dataSource.countersList.remove(at: index!)
			dataSource.saveToDefaults()
			self.navigationController?.popViewController(animated: true)
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

		self.present(alert, animated: true)
	}

	
	// MARK : - UITextFieldDelegate Methods
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		for textField in textFieldsUI {
			textField.resignFirstResponder()
		}
		return true;
	}
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let text = textField.text!
		let newLength = text.count + string.count - range.length
		
		switch textField {
		case unitTextField:
			return newLength <= 1
		case nameTextField:
			return newLength <= 18
		default:
			return true
		}
	}
	
	
}
