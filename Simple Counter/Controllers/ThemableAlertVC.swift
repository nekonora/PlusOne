//
//  ThemableAlertVC.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 23/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


protocol CustomAlertViewDelegate: class {
	func okButtonTapped(counterID: UUID?, alertType: alertType, textFieldValue: String)
	func cancelButtonTapped()
}


enum alertType {
	case addCounter
	case deleteCounter
	case resetCounter
	case deleteAll
}


class ThemableAlertVC: UIViewController {

	
	// MARK: - Outlets
	@IBOutlet var titleLabel		: UILabel!
	@IBOutlet var descriptionLabel 	: UILabel!
	@IBOutlet var textField 		: UITextField!
	@IBOutlet var wrapperView 		: UIView!
	@IBOutlet var cancelButton 		: UIButton!
	@IBOutlet var okButton 			: UIButton!
	
	
	// MARK: - Properties
	var alertTitle			: String?
	var alertDescription	: String?
	var alertKeyboardType	: UIKeyboardType?
	var alertPlaceholder	: String?
	var alertOkButtonText	: String?
	var alertAction 		: alertType!
	var alertCounterID		: UUID?
	
	let theme 				= ThemeManager.currentTheme()
	
	
	// MARK: - Actions
	@IBAction func onTapCancelButton(_ sender: Any) {
		textField.resignFirstResponder()
		delegate?.cancelButtonTapped()
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onTapOkButton(_ sender: Any) {
		textField.resignFirstResponder()
		delegate?.okButtonTapped(counterID: alertCounterID, alertType: alertAction, textFieldValue: textField.text!)
		self.dismiss(animated: true, completion: nil)
	}
	
	
	// MARK: - Properties
	var delegate: CustomAlertViewDelegate?
	
	
	// MARK: - Lifecylce Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		if alertAction != alertType.deleteCounter && alertAction != alertType.deleteAll { textField.becomeFirstResponder() }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
		animateView()
		
	}
	
	
	// MARK: - Private Methods
	fileprivate func setupView() {
		wrapperView.layer.cornerRadius 	= 15
		wrapperView.backgroundColor 	= theme.backgroundColor.withAlphaComponent(0.6)
		okButton.setTitle(alertOkButtonText ?? "Add", for: .normal)
		setBlurView(view: wrapperView)
		okButton.setTitleColor(theme.textColor, for: .normal)
		titleLabel.textColor 			= theme.textColor
		descriptionLabel.textColor 		= theme.textColor
		descriptionLabel.alpha			= 0.7
		
		if alertAction == alertType.deleteCounter || alertAction == alertType.deleteAll {
			textField.isHidden = true
			okButton.setAttributedTitle(NSAttributedString(string: alertOkButtonText ?? "",
														   attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
																		NSAttributedString.Key.foregroundColor: theme.deletionColor]),
														   for: .normal)
		} else {
			textField.backgroundColor		= theme.backgroundColor.withAlphaComponent(0.5) //UIColor(named: "notQuiteBlack")?.withAlphaComponent(0.5)
			textField.textColor				= theme.textColor
			textField.keyboardAppearance 	= UIKeyboardAppearance.dark
			textField.keyboardType			= alertKeyboardType ?? UIKeyboardType.default
			textField.attributedPlaceholder = NSAttributedString(string: alertPlaceholder ?? "",
																 attributes: [NSAttributedString.Key.foregroundColor: theme.textColor.withAlphaComponent(0.6)])
		}
		
		self.view.backgroundColor 		= UIColor.black.withAlphaComponent(0.8)
		
		titleLabel.text					= alertTitle
		descriptionLabel.text			= alertDescription
		
		cancelButton.addBorder(side: .Top, color: theme.tintColor.withAlphaComponent(0.4), width: 1)
		cancelButton.addBorder(side: .Right, color: theme.tintColor.withAlphaComponent(0.4), width: 1)
		okButton.addBorder(side: .Top, color: theme.tintColor.withAlphaComponent(0.4), width: 1)
	}
	
	fileprivate func animateView() {
		wrapperView.alpha = 0;
		self.wrapperView.frame.origin.y = self.wrapperView.frame.origin.y + 30
		UIView.animate(withDuration: 0.3, animations: { () -> Void in
			self.wrapperView.alpha = 1.0;
			self.wrapperView.frame.origin.y = self.wrapperView.frame.origin.y - 30
		})
	}

	fileprivate func setBlurView(view: UIView) {
		let blurView = UIVisualEffectView()
		blurView.frame = view.bounds
		
		switch theme {
		case .ocean:
			blurView.effect = UIBlurEffect(style: .dark)
		case .sunrise:
			blurView.effect = UIBlurEffect(style: .light)
		}
		
		blurView.layer.cornerRadius = 15
		blurView.clipsToBounds = true
		view.addSubview(blurView)
		view.sendSubviewToBack(blurView)
	}
	
	
}
