//
//  LoginViewController.swift
//  aries
//
//  Created by Mar Cabrera on 25/05/2022.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: LoadingButton!
    @IBOutlet weak var createAccountLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        setEmailField()
        // We have to use NSAttributes to change the color of the placeholder
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9472092986, green: 0.912545681, blue: 0.8959150314, alpha: 1)])

        let logoImage = UIImage(named: "logo")?.withTintColor(#colorLiteral(red: 0.9472092986, green: 0.912545681, blue: 0.8959150314, alpha: 1))
        logoImageView.image = logoImage
        
        setCreateAccountLabel()
    }

    // MARK: - Private Helpers
    private func setEmailField() {
        // Set email placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9472092986, green: 0.912545681, blue: 0.8959150314, alpha: 1)])

        emailTextField.delegate = self
        emailErrorLabel.isHidden = true
    }

    private func setCreateAccountLabel() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(createAccountLabelTapped(_:)))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(labelTap)
    }

    @objc func createAccountLabelTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToCreateAccount", sender: nil)
    }
    
    
    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButton.showLoading()

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            DispatchQueue.main.async {
                self.loginButton.hideLoading()
                switch result {
                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                    self.presentErrorAlert(message: "Invalid Credentials")

                case .success(let user):
                    print("Successfully logged in as user \(user)")

                    self.performSegue(withIdentifier: "goToLaunches", sender: nil)
                }
            }
        }
    }
}

// MARK: - Textfield Delegate
extension LoginViewController: UITextFieldDelegate {
    // Email validation when textfield loses focus
    // Might need to add password validation

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let email = emailTextField.text ?? ""
        if !Validation().isValidEmail(strToValidate: email) {
            emailErrorLabel.isHidden = false
            emailErrorLabel.text = "Please enter a valid email address"
        } else {
            emailErrorLabel.isHidden = true
        }
        return true
    }
}
