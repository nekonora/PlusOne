//
//  UIView+Constraints.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

extension UIView {
    
    func setConstraints(_ constraintBlock: ((UIView) -> Void)) {
        translatesAutoresizingMaskIntoConstraints = false
        constraintBlock(self)
        layoutIfNeeded()
    }
    
    func fillSuperview(padding: Int? = nil) {
        guard let superview = superview else { return }
        setConstraints {
            $0.top(to: superview.topAnchor, constant: padding ?? 0)
            $0.bottom(to: superview.bottomAnchor, constant: -(padding ?? 0))
            $0.leading(to: superview.leadingAnchor, constant: padding ?? 0)
            $0.trailing(to: superview.trailingAnchor, constant: -(padding ?? 0))
        }
    }
    
    func fillSafeArea(padding: Int? = nil) {
        guard let superview = superview?.safeAreaLayoutGuide else { return }
        setConstraints {
            $0.top(to: superview.topAnchor, constant: padding ?? 0)
            $0.bottom(to: superview.bottomAnchor, constant: -(padding ?? 0))
            $0.leading(to: superview.leadingAnchor, constant: padding ?? 0)
            $0.trailing(to: superview.trailingAnchor, constant: -(padding ?? 0))
        }
    }
    
    func top(to anchor: NSLayoutYAxisAnchor, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func bottom(to anchor: NSLayoutYAxisAnchor, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func leading(to anchor: NSLayoutXAxisAnchor, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func trailing(to anchor: NSLayoutXAxisAnchor, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = trailingAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func centerX(to anchor: NSLayoutXAxisAnchor, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func centerY(to anchor: NSLayoutYAxisAnchor, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func width(_ value: Int, priority: UILayoutPriority = .required) {
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(value))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func height(_ value: Int, priority: UILayoutPriority = .required) {
        let constraint = heightAnchor.constraint(equalToConstant: CGFloat(value))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func width(to anchor: NSLayoutDimension, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = widthAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func height(to anchor: NSLayoutDimension, constant: Int = 0, priority: UILayoutPriority = .required) {
        let constraint = heightAnchor.constraint(equalTo: anchor, constant: CGFloat(constant))
        constraint.priority = priority
        constraint.isActive = true
    }
}
