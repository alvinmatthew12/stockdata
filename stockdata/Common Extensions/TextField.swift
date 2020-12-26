//
//  TextField.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import UIKit

extension UITextField {
    
    func addBorder(radius: CGFloat, color: CGColor = UIColor.gray.cgColor) {
        layer.borderWidth = 1
        layer.borderColor = color
        layer.cornerRadius = radius
    }
    
    enum PaddingSpace {
        case left(CGFloat)
        case right(CGFloat)
        case equalSpacing(CGFloat)
    }
    
    func addPadding(padding: PaddingSpace) {
        leftViewMode = .always
        layer.masksToBounds = true
        
        switch padding {
        case .left(let spacing):
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always
        case .right(let spacing):
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = rightPaddingView
            self.rightViewMode = .always
        case .equalSpacing(let spacing):
            let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = equalPaddingView
            self.leftViewMode = .always
            self.rightView = equalPaddingView
            self.rightViewMode = .always
        }
    }
    
}
