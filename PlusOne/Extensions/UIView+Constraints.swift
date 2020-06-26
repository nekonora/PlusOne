//
//  UIView+Constraints.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

extension UIView {
    
    func setConstraint(_ constraintBlock: ((UIView) -> Void)) {
        translatesAutoresizingMaskIntoConstraints = false
        constraintBlock(self)
        layoutIfNeeded()
    }
    
    func fillSuperview(padding: Int? = nil) {
        guard let superview = superview else { return }
        setConstraint() {
            $0.top(to: superview.topAnchor, constant: padding ?? 0)
            $0.bottom(to: superview.bottomAnchor, constant: -(padding ?? 0))
            $0.leading(to: superview.leadingAnchor, constant: padding ?? 0)
            $0.trailing(to: superview.trailingAnchor, constant: -(padding ?? 0))
        }
    }
    
    func fillSafeArea(padding: Int? = nil) {
        guard let superview = superview?.safeAreaLayoutGuide else { return }
        setConstraint() {
            $0.top(to: superview.topAnchor, constant: padding ?? 0)
            $0.bottom(to: superview.bottomAnchor, constant: -(padding ?? 0))
            $0.leading(to: superview.leadingAnchor, constant: padding ?? 0)
            $0.trailing(to: superview.trailingAnchor, constant: -(padding ?? 0))
        }
    }
    
    func top(to anchor: NSLayoutYAxisAnchor, constant: Int = 0) {
        topAnchor.constraint(equalTo: anchor, constant: CGFloat(constant)).isActive = true
    }
    
    func bottom(to anchor: NSLayoutYAxisAnchor, constant: Int = 0) {
        bottomAnchor.constraint(equalTo: anchor, constant: CGFloat(constant)).isActive = true
    }
    
    func leading(to anchor: NSLayoutXAxisAnchor, constant: Int = 0) {
        leadingAnchor.constraint(equalTo: anchor, constant: CGFloat(constant)).isActive = true
    }
    
    func trailing(to anchor: NSLayoutXAxisAnchor, constant: Int = 0) {
        trailingAnchor.constraint(equalTo: anchor, constant: CGFloat(constant)).isActive = true
    }
    
    func centerX(to anchor: NSLayoutXAxisAnchor, constant: Int = 0) {
        centerXAnchor.constraint(equalTo: anchor, constant: CGFloat(constant)).isActive = true
    }
    
    func centerY(to anchor: NSLayoutYAxisAnchor, constant: Int = 0) {
        centerYAnchor.constraint(equalTo: anchor, constant: CGFloat(constant)).isActive = true
    }
    
    func width(_ value: Int) {
        widthAnchor.constraint(equalToConstant: CGFloat(value)).isActive = true
    }
    
    func height(_ value: Int) {
        heightAnchor.constraint(equalToConstant: CGFloat(value)).isActive = true
    }
}
