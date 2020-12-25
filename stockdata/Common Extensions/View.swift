//
//  View.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import UIKit

extension UIView {
    
    func addShadow(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.gray.cgColor
        layer.masksToBounds = true
    
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 1)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
        layer.rasterizationScale = 1
    }
    
    func addBorder(radius: CGFloat, width: CGFloat = 0.2, color: CGColor = UIColor.gray.cgColor) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color
    }
}
