//
//  ThemableAlertVC.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 23/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


protocol CustomAlertViewDelegate: class {
	func okButtonTapped(textFieldValue: String)
	func cancelButtonTapped()
}


class ThemableAlertVC: UIViewController {

	
	// MARK: - Outlets
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var descriptionLabel 	: UILabel!
	@IBOutlet var textField 		: UITextField!
	@IBOutlet var wrapperView 		: UIView!
	@IBOutlet var cancelButton 		: UIButton!
	@IBOutlet var okButton 			: UIButton!
	
	
	// MARK: - Actions
	@IBAction func onTapCancelButton(_ sender: Any) {
		textField.resignFirstResponder()
		delegate?.cancelButtonTapped()
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onTapOkButton(_ sender: Any) {
		textField.resignFirstResponder()
		delegate?.okButtonTapped(textFieldValue: textField.text!)
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Properties
	var delegate: CustomAlertViewDelegate?
	let accentColor = UIColor(named: "greenPastel")?.withAlphaComponent(0.6)
	
	
	// MARK: - Lifecylce Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		textField.becomeFirstResponder()
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
		wrapperView.backgroundColor 	= UIColor(red:0.07, green:0.33, blue:0.30, alpha:1.0)
		titleLabel.textColor 			= UIColor(named: "notQuiteWhite")!
		descriptionLabel.textColor 		= UIColor(named: "notQuiteWhite")!
		descriptionLabel.alpha			= 0.7
		textField.backgroundColor		= UIColor(named: "notQuiteBlack")?.withAlphaComponent(0.5)
		textField.textColor				= UIColor(named: "notQuiteWhite")!
		textField.keyboardAppearance = UIKeyboardAppearance.dark
		self.view.backgroundColor 		= UIColor.black.withAlphaComponent(0.4)
		
		titleLabel.text					= "Counter's name"
		descriptionLabel.text			= "Enter a name for the counter"
	}
	
	fileprivate func animateView() {
		wrapperView.alpha = 0;
		self.wrapperView.frame.origin.y = self.wrapperView.frame.origin.y + 50
		UIView.animate(withDuration: 0.4, animations: { () -> Void in
			self.wrapperView.alpha = 1.0;
			self.wrapperView.frame.origin.y = self.wrapperView.frame.origin.y - 50
		})
	}

	
}
