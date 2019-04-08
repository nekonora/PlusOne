//
//  ScrollView+.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 08/04/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


extension UIScrollView {
	enum Position {
		case top
		case center
		case bottom
	}
	/// Scrolls scroll view to y position passed, animated
	func scroll(to position: Position, animated: Bool = true) {
		switch position {
		case .top:
			self.setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
		case .center:
			self.setContentOffset(CGPoint(x: 0, y: contentSize.height/2-self.frame.height/2), animated: animated)
		case .bottom:
			self.setContentOffset(CGPoint(x: 0, y: contentSize.height-self.frame.height), animated: animated)
		}
	}
	/// Scrolls scroll view to y value passed, animated
	func scroll(to position: CGFloat, animated: Bool = true) {
		self.setContentOffset(CGPoint(x: 0, y: position), animated: animated)
	}
	
	/// Scrolls scroll view by y value passed, animated
	func scroll(by position: CGFloat, animated: Bool = true) {
		self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y + position), animated: animated)
	}
	
	func scroll(to view: UIView, animated: Bool = true) {
		self.setContentOffset(CGPoint(x: 0, y: view.frame.maxY), animated: animated)
	}
}
