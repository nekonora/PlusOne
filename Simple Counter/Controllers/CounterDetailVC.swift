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
	@IBOutlet var iPadTopBar: UIView!
	@IBOutlet var iPadTopPadding: UIView!
	
	@IBOutlet var iPadCancelButton: UIButton!
	@IBOutlet var iPadSaveButton: UIButton!
	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var stepsTextField: UITextField!
	@IBOutlet var unitTextField: UITextField!
	@IBOutlet var completionTextField: UITextField!
	
	@IBOutlet var tagsTextField: TKTextField!
	
	@IBOutlet var allTagsWrapper: UIView!
	@IBOutlet var tagsWrapperView: UIView!
	
	@IBOutlet var tagsContainerView: UIView!
	@IBOutlet var allTagsContainer: UIView!
	
	
	// MARK: - Actions
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
	
	@IBAction func didTapiPadCancel(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func didTapiPadSave(_ sender: Any) {
		saveTapped()
	}
	
	
	// MARK: - Properties
	var counter			: CounterV2!
	var dataSource		: CountersDataSource!
	var tagsManager 	= TagsManager()
	
	let counterTagsCollection 	= TKCollectionView()
	let allTagsCollection		= TKCollectionView()
	
	let theme					= ThemeManager.currentTheme()
	let feedbackGenerator 		= UIImpactFeedbackGenerator(style: .light)
	var iPadDismissHandler		: (() -> Void) = {}
	
	
	// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupLayout()
		setupTextFields()
		setupSaveButton()
		
		allTagsWrapper.isHidden = true
		allTagsWrapper.alpha 	= 0
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		title = counter.name!
		
		// TaggerKit stuff
		let allTags 					= tagsManager.loadFromDefaults()
		
		counterTagsCollection.tags 		= counter.tags
		allTagsCollection.tags 			= allTags
		
		counterTagsCollection.action 	= .removeTag

		counterTagsCollection.delegate 	= self
		allTagsCollection.delegate 		= self
		
		allTagsCollection.receiver 		= counterTagsCollection
		
		allTagsCollection.action 		= .addTag
		
		tagsTextField.sender 			= allTagsCollection
		tagsTextField.receiver 			= counterTagsCollection
		
		setupTags()
		
		add(counterTagsCollection, toView: tagsContainerView)
		add(allTagsCollection, toView: allTagsContainer)
		
		setupTagsTextField()

		feedbackGenerator.prepare()
    }
	
	
	// MARK: - Setup Methods
	fileprivate func setupLayout() {
		if UIDevice.current.userInterfaceIdiom == .pad {
			iPadTopBar.isHidden 	= false
			iPadTopPadding.isHidden = false
		}
	}
	
	fileprivate func setupSaveButton() {
		let saveButton = UIButton()
		let attributes: [NSAttributedString.Key: Any] = [
			.font 			: UIFont.boldSystemFont(ofSize: 16),
			.foregroundColor: theme.textColor
		]
		let buttonTitle = NSAttributedString(string: NSLocalizedString("detail_saveButton", comment: "Save"), attributes: attributes)
		saveButton.frame = CGRect(x:0, y:0, width:70, height: 30)
		saveButton.setAttributedTitle(buttonTitle, for: .normal)
		
		let backgroundForNormal			= ThemeManager.getImageWithColor(color: theme.tintColor.withAlphaComponent(0.3), size: saveButton.frame.size)
		let backgroundForPressed		= ThemeManager.getImageWithColor(color: theme.tintColor.withAlphaComponent(0.2), size: saveButton.frame.size)
		
		saveButton.setBackgroundImage(backgroundForNormal, for: .normal)
		saveButton.setBackgroundImage(backgroundForPressed, for: .highlighted)
		saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
		saveButton.layer.cornerRadius = saveButton.frame.height / 2
		saveButton.clipsToBounds = true
		
		iPadSaveButton.setAttributedTitle(buttonTitle, for: .normal)
		iPadSaveButton.setBackgroundImage(backgroundForNormal, for: .normal)
		iPadSaveButton.setBackgroundImage(backgroundForPressed, for: .highlighted)
		iPadSaveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
		iPadSaveButton.layer.cornerRadius = saveButton.frame.height / 2
		iPadSaveButton.clipsToBounds = true
		
		let rightBarButton 						= UIBarButtonItem(customView: saveButton)
		self.navigationItem.rightBarButtonItem 	= rightBarButton
	}
	
	fileprivate func setupTextFields() {
		for textField in textFieldsUI {
			let leftView 					= UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
			textField.layer.cornerRadius 	=  15
			textField.leftView 				= leftView
			textField.leftViewMode 			= .always

			textField.layer.borderWidth 	= 1.0
			textField.layer.borderColor 	= UIColor(named: "greenPastel")!.cgColor
			textField.keyboardAppearance 	= UIKeyboardAppearance.dark
			textField.delegate 				= self
			textField.backgroundColor		= ThemeManager.currentTheme().tintColor.withAlphaComponent(0.1)
			textField.clipsToBounds 		= true
		}
		
		nameTextField.text 			= String(counter.name)
		stepsTextField.text 		= String(counter.steps)
		unitTextField.text 			= counter.unit
		completionTextField.text 	= String(counter.completionValue)
	}
	
	
	func setupTagsTextField() {
		let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
		tagsTextField.layer.cornerRadius 	=  15
		tagsTextField.leftView 				= leftView
		tagsTextField.leftViewMode 			= .always
		tagsTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("detail_tagsTextFieldPlaceholder", comment: "New tag"), attributes: [.foregroundColor : theme.textColor.withAlphaComponent(0.5)])
		
		tagsTextField.layer.borderWidth 	= 1.0
		tagsTextField.backgroundColor		= ThemeManager.currentTheme().tintColor.withAlphaComponent(0.1)
		tagsTextField.layer.borderColor 	= UIColor(named: "greenPastel")!.cgColor
		tagsTextField.keyboardAppearance 	= UIKeyboardAppearance.dark
	}
	
	
	func setupTags() {
		allTagsCollection.customFont 			= UIFont.boldSystemFont(ofSize: 14)
		allTagsCollection.customBackgroundColor = UIColor(named: "greenPastel")!
		
		counterTagsCollection.customFont 			= UIFont.boldSystemFont(ofSize: 14)
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
		feedbackGenerator.impactOccurred()
		
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
		
		if UIDevice.current.userInterfaceIdiom == .pad {
			dismiss(animated: true) {
				self.iPadDismissHandler()
			}
		} else if UIDevice.current.userInterfaceIdiom == . phone {
			navigationController?.popViewController(animated: true)
		}
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
			let index = dataSource.countersList.firstIndex{$0.id == id}
			
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
