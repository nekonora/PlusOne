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
	let accentColor = UIColor(named: "greenPastel")?.withAlphaComponent(0.2)
	
	
	// MARK: - Lifecylce Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		if alertAction != alertType.deleteCounter { textField.becomeFirstResponder() }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
		animateView()
		cancelButton.addBorder(side: .Top, color: accentColor!, width: 1)
		cancelButton.addBorder(side: .Right, color: accentColor!, width: 1)
		okButton.addBorder(side: .Top, color: accentColor!, width: 1)
	}
	
	
	// MARK: - Private Methods
	fileprivate func setupView() {
		wrapperView.layer.cornerRadius 	= 15
		wrapperView.backgroundColor 	= UIColor(red:0.07, green:0.33, blue:0.30, alpha:0.6)
		okButton.setTitle(alertOkButtonText ?? "Add", for: .normal)
		setBlurView(view: wrapperView)
		titleLabel.textColor 			= UIColor(named: "notQuiteWhite")!
		descriptionLabel.textColor 		= UIColor(named: "notQuiteWhite")!
		descriptionLabel.alpha			= 0.7
		
		if alertAction == alertType.deleteCounter || alertAction == alertType.deleteAll {
			textField.isHidden				= true
			okButton.setAttributedTitle(NSAttributedString(string: alertOkButtonText ?? "",
														   attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
																		NSAttributedString.Key.foregroundColor: theme.deletionColor]),
														   for: .normal)
		} else {
			textField.backgroundColor		= UIColor(named: "notQuiteBlack")?.withAlphaComponent(0.5)
			textField.textColor				= UIColor(named: "notQuiteWhite")!
			textField.keyboardAppearance 	= UIKeyboardAppearance.dark
			textField.keyboardType			= alertKeyboardType ?? UIKeyboardType.default
			textField.attributedPlaceholder = NSAttributedString(string: alertPlaceholder ?? "",
																 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
		}
		
		self.view.backgroundColor 		= UIColor.black.withAlphaComponent(0.6)
		
		titleLabel.text					= alertTitle ?? ""
		descriptionLabel.text			= alertDescription ?? ""
	}
	
	fileprivate func animateView() {
		wrapperView.alpha = 0;
		self.wrapperView.frame.origin.y = self.wrapperView.frame.origin.y + 50
		UIView.animate(withDuration: 0.4, animations: { () -> Void in
			self.wrapperView.alpha = 1.0;
			self.wrapperView.frame.origin.y = self.wrapperView.frame.origin.y - 50
		})
	}

	fileprivate func setBlurView(view: UIView) {
		let blurView = UIVisualEffectView()
		blurView.frame = view.bounds
		blurView.effect = UIBlurEffect(style: .dark)
		blurView.layer.cornerRadius = 15
		blurView.clipsToBounds = true
		view.addSubview(blurView)
		view.sendSubviewToBack(blurView)
	}
	
	
}
