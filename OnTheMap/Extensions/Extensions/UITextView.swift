//
//  UITextView.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/17/20.
//

import Foundation
import UIKit

extension UITextView {
    convenience public init(text: String?, font: UIFont? = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left) {
        self.init()
        self.text           = text
        self.font           = font
        self.textColor      = textColor
        self.textAlignment  = textAlignment
    }
}
