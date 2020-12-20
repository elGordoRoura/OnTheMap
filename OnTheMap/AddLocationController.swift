//
//  AddLocationController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit
import CoreLocation

class AddLocationController: EGFormController {
    
    private let needMoreRoomLabel       = UILabel(text: "Scroll up if the Find Location button is blocked",
                                                  font: .preferredFont(for: .body,
                                                                       weight: .thin),
                                                  textColor: .label,
                                                  textAlignment: .center,
                                                  numberOfLines: 2)
    
    private let firstNameTextField      = IndentedTextField(placeholder: "First name",
                                                            padding: 24,
                                                            cornerRadius: 25,
                                                            backgroundColor: .white)
    private let lastNameTextField       = IndentedTextField(placeholder: "Last name",
                                                            padding: 24,
                                                            cornerRadius: 25,
                                                            backgroundColor: .white)
    
    private let locationTextField       = IndentedTextField(placeholder: "Location",
                                                            padding: 24,
                                                            cornerRadius: 25,
                                                            backgroundColor: .white)
    private let urlTextField            = IndentedTextField(placeholder: "Url",
                                                            padding: 24,
                                                            cornerRadius: 25,
                                                            backgroundColor: .white)
    private let findLocationButton      = UIButton(title: "Find Location",
                                                   titleColor: .white,
                                                   font: .boldSystemFont(ofSize: 18),
                                                   backgroundColor: .black,
                                                   target: self,
                                                   action: #selector(handleFindLocation))
    
    private let activityIndicatorView   = UIActivityIndicatorView(style: .large)
    
    func showAIV() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hideAIV() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Location"
        
        setupBackgroundGradient()
        configureNavBar()
        configureUI()
    }
    
    
    fileprivate func setupBackgroundGradient() {
        let gradient = CAGradientLayer.init(start: .topLeft,
                                            end: .bottomRight,
                                            colors: [
                                                UIColor.systemBackground.cgColor,
                                                UIColor.systemBlue.cgColor])
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                 target: self,
                                                 action: #selector(handleCancel))
    }
    
    
    fileprivate func configureUI() {
        urlTextField.autocapitalizationType         = .none
        findLocationButton.layer.cornerRadius       = 25
        activityIndicatorView.color                 = .white
        
        let formView = UIView()
        formView.stack(
            UIView().withHeight(12),
            needMoreRoomLabel.withHeight(50),
            firstNameTextField.withHeight(50),
            lastNameTextField.withHeight(50),
            locationTextField.withHeight(50),
            urlTextField.withHeight(50),
            findLocationButton.withHeight(50),
            activityIndicatorView,
            UIView().withHeight(80),
            spacing: 16)
            .withMargins(.init(top: 48,
                               left: 32,
                               bottom: 0,
                               right: 32))
        
        formContainerStackView.padBottom(-24)
        formContainerStackView.addArrangedSubview(formView)
    }
    
    
    func findLocation(_ search: StudentLocation) {
        CLGeocoder().geocodeAddressString(search.mapString!) { (placemarks, error) in
            self.hideAIV()
            
            guard let firstLocation = placemarks?.first?.location else {
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToGetLocation.rawValue, buttonTitle: "Ok")
                return
            }
            var location        = search
            location.latitude   = firstLocation.coordinate.latitude
            location.longitude  = firstLocation.coordinate.longitude
            
            let finalLocationVC         = FinalLocationController()
            finalLocationVC.location    = location
            self.navigationController?.pushViewController(finalLocationVC, animated: true)
        }
    }
    
    
    // MARK: - OBJC Functions
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    
    @objc func handleFindLocation() {
        showAIV()
        
        guard let firstName = firstNameTextField.text,
              let lastName  = lastNameTextField.text,
              let location  = locationTextField.text,
              let url       = urlTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !location.isEmpty,
              !url.isEmpty else {
            self.presentEGAlertOnMainThread(title: "Error", message: EGError.invalidAddLocationData.rawValue, buttonTitle: "Ok")
            self.hideAIV()
            return
        }
        
        let studentLocation = StudentLocation(firstName: firstName,
                                              lastName: lastName,
                                              mapString: location,
                                              mediaURL: url)
        findLocation(studentLocation)
    }
}
