//
//  UILabel.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/17/20.
//

import UIKit

extension UILabel {
    convenience public init(text: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        self.text           = text
        self.font           = font
        self.textColor      = textColor
        self.textAlignment  = textAlignment
        self.numberOfLines  = numberOfLines
    }
}


extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc    = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font    = UIFont.systemFont(ofSize: desc.pointSize,
                                        weight: weight)
        return metrics.scaledFont(for: font)
    }
}
