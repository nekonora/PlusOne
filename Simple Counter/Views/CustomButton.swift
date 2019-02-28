//
//  CustomButton.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 25/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit


@IBDesignable
public class CustomButton: UIButton {
	
	
	@IBInspectable
	public var cornerRadius: CGFloat = 2.0 {
		didSet {
			self.layer.cornerRadius = self.cornerRadius
		}
	}
	
	
	@IBInspectable
	public var backroundColor: UIColor = UIColor.clear {
		didSet {
			self.layer.backgroundColor = self.backroundColor.cgColor
		}
	}
	
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		titleLabel?.baselineAdjustment = .alignCenters
		
		// .normal state
		setTitle("MyTitle", for: .normal)
		setTitleColor(UIColor.blue, for: .normal)
	}
	
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
}


