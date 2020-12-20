//
//  UIColor+Helpers.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/17/20.
//

import UIKit

extension UIColor {
    static public func rgb(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
