//
//  LoginController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/17/20.
//

import UIKit
import SwiftUI

class LoginController: EGFormController {
    
    let logoImageView                   = UIImageView(image: #imageLiteral(resourceName: "logo-u"), contentMode: .scaleAspectFit)
    let signInLabel                     = UILabel(text: "Sign In",
                                                  font: .preferredFont(for: .largeTitle,
                                                                       weight: .heavy),
                                                  textColor: .black,
                                                  textAlignment: .natural,
                                                  numberOfLines: 0)
    
    let emailTextField                  = IndentedTextField(placeholder: "Email",
                                                            padding: 24,
                                                            cornerRadius: 25,
                                                            keyboardType: .emailAddress,
                                                            backgroundColor: .white)
    let passwordTextField               = IndentedTextField(placeholder: "Password",
                                                            padding: 24,
                                                            cornerRadius: 25,
                                                            backgroundColor: .white,
                                                            isSecureTextEntry: true)
    
    var isSecure                        = true
    var isSecureButton                  = UIButton(image: UIImage(systemName: "eye")!,
                                                   tintColor: .black,
                                                   target: self,
                                                   action: #selector(handleIsPasswordSecure))
    
    lazy var loginButton                = UIButton(title: "Login",
                                                   titleColor: .white,
                                                   font: .boldSystemFont(ofSize: 18),
                                                   backgroundColor: .black,
                                                   target: self,
                                                   action: #selector(handleSignIn))
    
    lazy var signUpButton               = UIButton(attributedTitle: "Don't have an account?",
                                                   attributedButtonText: "Sign up.",
                                                   target: self,
                                                   action: #selector(handleSignUp))
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        configureUI()
    }
    
    
    fileprivate func setupGradient() {
        let gradient = CAGradientLayer.init(start: .topLeft,
                                            end: .bottomRight,
                                            colors: [
                                                UIColor.systemBackground.cgColor,
                                                UIColor.systemBlue.cgColor])
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    fileprivate func configureUI() {
        emailTextField.autocapitalizationType   = .none
        loginButton.layer.cornerRadius          = 25
        activityIndicatorView.color             = .white
        
        let formView = UIView()
        formView.stack(
            formView.stack(
                formView.hstack(
                    logoImageView.withSize(.init(width: 80, height: 80)),
                    signInLabel.withWidth(160), spacing: 16, alignment: .center)
                    .padLeft(12).padRight(12), alignment: .center),
            UIView().withHeight(12),
            emailTextField.withHeight(50),
            formView.hstack(
                passwordTextField.withHeight(50),
                isSecureButton, spacing: 8, alignment: .center),
            loginButton.withHeight(50),
            signUpButton,
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
    
    
    // MARK: - OBJC Functions
    
    @objc func handleIsPasswordSecure() {
        isSecure.toggle()
        if isSecure {
            UIView.animate(withDuration: 0) {
                self.isSecureButton.setImage(UIImage(systemName: "eye"), for: .normal)
                self.passwordTextField.isSecureTextEntry = true
            }
        } else {
            UIView.animate(withDuration: 0) {
                self.isSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                self.passwordTextField.isSecureTextEntry = false
            }
        }
    }
    
    @objc func handleSignIn() {
        showAIV()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text
              else { return }
        
        OTMApi.signIn(email, password) { (result) in
            switch result {
            case .failure:
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.invalidUsername.rawValue, buttonTitle: "Ok")
                self.hideAIV()
                return
                
            case .success:
                self.hideAIV()
                
                let homeController = MainTabBarController()
                homeController.modalPresentationStyle = .fullScreen
                
                self.emailTextField.text?.removeAll()
                self.passwordTextField.text?.removeAll()
                
                self.present(homeController, animated: true)
            }
        }
    }
    
    
    @objc func handleSignUp() {
        UIApplication.shared.open(Endpoints.webAuth.url, options: [:], completionHandler: nil)
    }
}


// MARK: - PREVIEW

struct LoginController_Previews: PreviewProvider {
    static var previews: some View {
        LoginControllerContainerView()
            .edgesIgnoringSafeArea(.all)
    }
    
    
    struct LoginControllerContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = LoginController
        
        func makeUIViewController(context: Context) -> LoginController {
            LoginController()
        }
        
        func updateUIViewController(_ uiViewController: LoginController, context: Context) {
        }
    }
}
