//
//  String+Helpers.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/20/20.
//

import UIKit

extension String {
    public func formatURL() -> String {
        let newString = replacingOccurrences(of: "www.", with: "https://www.").lowercased()
        return newString
    }
}
