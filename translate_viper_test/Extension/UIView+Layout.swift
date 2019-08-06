//
//  UIView+Layout.swift
//  xkee
//
//  Created by Denis on 22/04/2019.
//  Copyright © 2019 halfakop.ru. All rights reserved.
//

import UIKit

extension UIView {
	
	@discardableResult
	func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero, priority: Float? = 1000) -> AnchoredConstraints {
		
		translatesAutoresizingMaskIntoConstraints = false
		var anchoredConstraints = AnchoredConstraints()
		
		if let top = top {
			anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
			if let priority = priority {
				anchoredConstraints.top?.priority = .init(priority)
			}
		}
		
		if let leading = leading {
			anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
			if let priority = priority {
				anchoredConstraints.leading?.priority = .init(priority)
			}
		}
		
		if let bottom = bottom {
			anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
			if let priority = priority {
				anchoredConstraints.bottom?.priority = .init(priority)
			}
		}
		
		if let trailing = trailing {
			anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
			if let priority = priority {
				anchoredConstraints.trailing?.priority = .init(priority)
			}
		}
		
		if size.width != 0 {
			anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
			if let priority = priority {
				anchoredConstraints.width?.priority = .init(priority)
			}
		}
		
		if size.height != 0 {
			anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
			if let priority = priority {
				anchoredConstraints.height?.priority = .init(priority)
			}
		}
		
		[anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
		
		return anchoredConstraints
	}
	
	func fillSuperview(padding: UIEdgeInsets = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewTopAnchor = superview?.topAnchor {
			topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
		}
		
		if let superviewBottomAnchor = superview?.bottomAnchor {
			bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
		}
		
		if let superviewLeadingAnchor = superview?.leadingAnchor {
			leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
		}
		
		if let superviewTrailingAnchor = superview?.trailingAnchor {
			trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
		}
	}
	
	func centerInSuperview(size: CGSize = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
		}
		
		if let superviewCenterYAnchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
		}
		
		if size.width != 0 {
			widthAnchor.constraint(equalToConstant: size.width).isActive = true
		}
		
		if size.height != 0 {
			heightAnchor.constraint(equalToConstant: size.height).isActive = true
		}
	}
	
	func centerXInSuperview() {
		translatesAutoresizingMaskIntoConstraints = false
		if let superViewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
		}
	}
	
	func centerYInSuperview() {
		translatesAutoresizingMaskIntoConstraints = false
		if let centerY = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: centerY).isActive = true
		}
	}
	
	func constrainWidth(constant: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: constant).isActive = true
	}
	
	func constrainHeight(constant: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		heightAnchor.constraint(equalToConstant: constant).isActive = true
	}
	
	func constrainHeight(constant: CGFloat, priority: Float) {
		translatesAutoresizingMaskIntoConstraints = false
		let height      = heightAnchor.constraint(equalToConstant: constant)
		height.priority = UILayoutPriority(priority)
		height.isActive = true
	}
	
	func constrainWidth(constant: CGFloat, priority: Float) {
		translatesAutoresizingMaskIntoConstraints = false
		let width      = widthAnchor.constraint(equalToConstant: constant)
		width.priority = UILayoutPriority(priority)
		width.isActive = true
	}
}

struct AnchoredConstraints {
	var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
	
	convenience init(width: CGFloat, height: CGFloat) {
		self.init(frame: .init(x: 0, y: 0, width: width, height: height))
		if height != 0 {
			self.constrainHeight(constant: height)
		}
		if width != 0 {
			self.constrainWidth(constant: width)
		}
	}
	
	convenience init(width: CGFloat, height: CGFloat, color: UIColor) {
		self.init(frame: .init(x: 0, y: 0, width: width, height: height))
		if height != 0 {
			self.constrainHeight(constant: height)
		}
		if width != 0 {
			self.constrainWidth(constant: width)
		}
		self.backgroundColor = color
	}
	
}
