//
//  CounterDetailVC.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 27/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit
import TaggerKit


class CounterDetailVC: UIViewController, UITextFieldDelegate {
	
	
	// MARK: - Outlets
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var textFieldsUI: [UITextField]!
	
	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var stepsTextField: UITextField!
	@IBOutlet var unitTextField: UITextField!
	@IBOutlet var completionTextField: UITextField!
	
	@IBOutlet var tagsTextField: TKTextField!
	
	@IBOutlet var allTagsWrapper: UIView!
	@IBOutlet var tagsWrapperView: UIView!
	
	@IBOutlet var tagsContainerView: UIView!
	@IBOutlet var allTagsContainer: UIView!
	
	@IBAction func tagsTextFieldEditingBegin(_ sender: Any) {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.allTagsWrapper.isHidden 	= false
			self.allTagsWrapper.alpha 		= 1
		}
	}
	
	@IBAction func tagsTextFieldEndEditing(_ sender: Any) {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.allTagsWrapper.isHidden 	= true
			self.allTagsWrapper.alpha 		= 0
		}
	}
	
	@IBAction func deleteTapped(_ sender: Any) {
		deleteCounter(dataSource: dataSource)
	}
	
	
	// MARK: - Properties
	var counter			: CounterV2!
	var dataSource		: CountersDataSource!
	var tagsManager 	= TagsManager()
	
	let counterTagsCollection 	= TKCollectionView()
	let allTagsCollection		= TKCollectionView()
	
	
	// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupTextFields()
		setupSaveButton()
		
		allTagsWrapper.isHidden = true
		allTagsWrapper.alpha 	= 0
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		title = counter.name!
		
		// TaggerKit stuff
		let allTags = tagsManager.loadFromDefaults()
		
//		counterTagsCollection.tags = ["Tech", "Design", "Writing", "Social Media"]
		counterTagsCollection.tags = counter.tags
		
//		allTagsCollection.tags = ["Cars", "Skateboard", "Freetime", "Humor", "Travel", "Music", "Places", "Journalism", "Music", "Sports"]
		allTagsCollection.tags = allTags
		
		
		counterTagsCollection.action = .removeTag

		counterTagsCollection.delegate = self
		allTagsCollection.delegate = self
		
		allTagsCollection.receiver = counterTagsCollection
		
		allTagsCollection.action = .addTag
		
		tagsTextField.sender 	= allTagsCollection
		tagsTextField.receiver 	= counterTagsCollection
		
		setupTags()
		
		add(counterTagsCollection, toView: tagsContainerView)
		add(allTagsCollection, toView: allTagsContainer)
		
		setupTagsTextField()
		
    }
	
	
	// MARK: - Setup Methods
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
	
	
	func setupTagsTextField() {
		tagsTextField.layer.cornerRadius =  15
		let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
		tagsTextField.leftView = leftView
		tagsTextField.leftViewMode = .always
		
		tagsTextField.layer.borderWidth = 1.0
		tagsTextField.layer.borderColor = UIColor(named: "greenPastel")!.cgColor
		tagsTextField.keyboardAppearance = UIKeyboardAppearance.dark
	}
	
	
	func setupTags() {
		allTagsCollection.customFont = UIFont.boldSystemFont(ofSize: 14)
		allTagsCollection.customBackgroundColor = UIColor(named: "greenPastel")!
		
		counterTagsCollection.customFont = UIFont.boldSystemFont(ofSize: 14)
		counterTagsCollection.customBackgroundColor = UIColor(named: "pastelOrange")!
	}
	
	
	// MARK: - TaggerKit delegate
	override func tagIsBeingAdded(name: String?) {
		//
	}
	
	
	override func tagIsBeingRemoved(name: String?) {
		//
	}
	
	
	// MARK: - Action methods
	@objc fileprivate func saveTapped() {
		
		let newName 			= nameTextField.text ?? ""
		let newUnit 			= unitTextField.text ?? ""
		let newSteps			: Float
		let newCompletion		: Float
		let newTags				= counterTagsCollection.tags
		
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
		
		for tag in newTags {
			let allTags = tagsManager.loadFromDefaults()
			if !allTags.contains(tag) {
				tagsManager.addTag(named: tag)
			}
		}
		
		updateCounter(dataSource			: dataSource,
					  id					: counter.id,
					  newName				: newName,
					  newSteps				: newSteps,
					  newUnit				: newUnit,
					  newCompletionValue	: newCompletion,
					  newTags				: newTags )
		
		navigationController?.popViewController(animated: true)
	}
	
	
	@objc func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!

		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

		if notification.name == UIResponder.keyboardWillHideNotification {
			scrollView.contentInset = UIEdgeInsets.zero
		} else {
			scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 180, right: 0)
		}

		scrollView.scrollIndicatorInsets = scrollView.contentInset
	}
	
	
	fileprivate func updateCounter(dataSource: CountersDataSource,
					   id					: UUID,
					   newName				: String,
					   newSteps				: Float,
					   newUnit				: String,
					   newCompletionValue	: Float,
					   newTags				: [String]) {
		
		if let tempCounter = dataSource.countersList.filter( { $0.id == id } ).first {
			let index = dataSource.countersList.index{$0.id == id}
			
			tempCounter.name 			= newName
			tempCounter.steps 			= newSteps
			tempCounter.unit 			= newUnit
			tempCounter.completionValue = newCompletionValue
			tempCounter.tags			= newTags
			
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
