//
//  TagHeaderView.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


class TagHeaderView: UICollectionReusableView {
	
	
	// MARK: - Properties
	var titleLabel: UILabel = {
		let label = UILabel()
		label.custom(title: "Title", font: .systemFont(ofSize: 16), titleColor: UIColor(named: "notQuiteWhite")!, textAlignment: .left, numberOfLines: 1)
		return label
	}()
	
	var lineDivider1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
	var lineDivider2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
	
	
	// MARK: - Lifecycle Methods
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}


extension TagHeaderView : ViewSetable {
	
	func setupViews() {
		autoresizingMask = [.flexibleWidth, .flexibleHeight]
		lineDivider1.backgroundColor = UIColor(named: "greenPastel")
		lineDivider2.backgroundColor = UIColor(named: "greenPastel")
		addSubview(titleLabel)
//		addSubview(lineDivider1)
//		addSubview(lineDivider2)
	}
	
	func setupConstraints() {
		titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		
	}
	
	
}


extension UILabel {
	
	func custom(title: String, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int) {
		self.text 										= title
		self.textAlignment 								= textAlignment
		self.font 										= font
		self.textColor 									= titleColor
		self.numberOfLines 								= numberOfLines
		self.adjustsFontSizeToFitWidth 					= true
		self.translatesAutoresizingMaskIntoConstraints 	= false
	}
	
}


protocol ViewSetable {
		func setupViews()
		func setupConstraints()
}
