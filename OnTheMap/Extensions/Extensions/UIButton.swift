//
//  UIButton.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/17/20.
//

import UIKit

@available(iOS 11.0, tvOS 11.0, *)
extension UIButton {
    
    convenience public init(title: String, titleColor: UIColor = .clear, font: UIFont = .systemFont(ofSize: 14), backgroundColor: UIColor = .clear, target: Any? = nil, action: Selector? = nil) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font   = font
        self.backgroundColor    = backgroundColor
        
        if let action = action {
            addTarget(target, action: action, for: .primaryActionTriggered)
        }
    }
    
    convenience public init(image: UIImage, tintColor: UIColor? = nil, target: Any? = nil, action: Selector? = nil) {
        self.init(type: .system)
        if tintColor == nil {
            setImage(image, for: .normal)
        } else {
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            self.tintColor = tintColor
        }
        
        if let action = action {
            addTarget(target, action: action, for: .primaryActionTriggered)
        }
    }
    
    convenience public init(attributedTitle: String, attributedButtonText: String, backgroundColor: UIColor = .clear, target: Any? = nil, action: Selector? = nil) {
        self.init(type: .system)
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(for: .body,
                                        weight: .thin),
            .foregroundColor: UIColor.black,
        ]
        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(for: .body,
                                        weight: .semibold),
            .foregroundColor: UIColor.white,
        ]

        let attributedTitle = NSMutableAttributedString(string: attributedTitle,
                                                        attributes: defaultAttributes)
        attributedTitle.append(NSAttributedString(string: "  \(attributedButtonText)",
                                                  attributes: buttonAttributes))
        
        setAttributedTitle(attributedTitle, for: .normal)
        self.backgroundColor    = backgroundColor
        
        if let action = action {
            addTarget(target, action: action, for: .primaryActionTriggered)
        }
    }
}
