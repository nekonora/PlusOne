//
//  SettingsViewController.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


class SettingsViewController: UIViewController {

	
	// MARK: - Outlets
	@IBOutlet var stackView: UIStackView!
	@IBOutlet var twitterButtonOutlet: UIButton!
	@IBOutlet var iPadTopBar: UIView!
	
	
	// MARK: - Actions
	@IBAction func twitterButtonTapped(_ sender: Any) {
		guard twitterURL != nil else { return }
		UIApplication.shared.open(twitterURL!)
	}
	
	@IBAction func didTapiPadBack(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	
	// MARK: - Properties
	let twitterURL = URL(string: "https://twitter.com/_nknr")
	
	// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		setupLayout()
	}
	
	
	// MARK: - Private Methods
	fileprivate func setupLayout() {
		if UIDevice.current.userInterfaceIdiom == .pad {
			iPadTopBar.isHidden = false
		}
	}

}
