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
		label.custom(title			: "",
					 font			: .boldSystemFont(ofSize: 16),
					 titleColor		: UIColor(named: "notQuiteWhite")!,
					 textAlignment	: .center,
					 numberOfLines	: 1)
		return label
	}()
	
	var lineDivider1 = UIView()
	var lineDivider2 = UIView()
	
	
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
		autoresizingMask 				= [.flexibleWidth, .flexibleHeight]
		lineDivider1.backgroundColor 	= UIColor(named: "greenPastel")
		lineDivider2.backgroundColor 	= UIColor(named: "greenPastel")
		addSubview(titleLabel)
		addSubview(lineDivider1)
		addSubview(lineDivider2)
	}
	
	func setupConstraints() {
		titleLabel.snp.makeConstraints { (make) in
			make.top.bottom.equalToSuperview()
			make.centerY.centerX.equalToSuperview()
		}
		
		lineDivider1.snp.makeConstraints { (make) in
			make.height.equalTo(1)
			make.right.equalTo(titleLabel.snp.left).offset(-20)
			make.left.equalToSuperview().offset(20)
			make.centerY.equalToSuperview()
		}
		
		lineDivider2.snp.makeConstraints { (make) in
			make.height.equalTo(1)
			make.left.equalTo(titleLabel.snp.right).offset(20)
			make.right.equalToSuperview().offset(-20)
			make.centerY.equalToSuperview()
		}
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
