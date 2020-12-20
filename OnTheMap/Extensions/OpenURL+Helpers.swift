//
//  OpenURL+Helpers.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/20/20.
//

import UIKit

extension UIViewController {
    public func openURL(_ urlString: String) {
        let newURLString = urlString.formatURL()
        
        guard let url = URL(string: newURLString) else {
            self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToOpenURL.rawValue, buttonTitle: "Ok")
            return
        }
        UIApplication.shared.open(url, options: [:]) { success in
            if !success {
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToOpenURL.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
