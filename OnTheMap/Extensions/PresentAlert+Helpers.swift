//
//  PresentAlert+Helpers.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/20/20.
//

import UIKit

extension UIViewController {
    func presentEGAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = EGAlertController(title: title,
                                            message: message,
                                            buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
