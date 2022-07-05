//
//  CreateAccountViewController.swift
//  aries
//
//  Created by Mar Cabrera on 01/06/2022.
//

import UIKit
import RealmSwift

class CreateAccountViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: LoadingButton!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setEmailField()
        setPasswordField()
    }

    // MARK: - Private Helpers
    private func setEmailField() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email@example.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailTextField.delegate = self
        emailErrorLabel.isHidden = true
    }

    private func setPasswordField() {
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    // MARK: - IBActions
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        createAccountButton.showLoading()
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        app.emailPasswordAuth.registerUser(email: email, password: password, completion: { (error) in
            DispatchQueue.main.async {
                self.createAccountButton.hideLoading()
                guard error == nil else {
                    self.presentErrorAlert(message: "Oops! There was an error on sign up")
                    return
                }

                print("Signup Successful!")
                self.signIn(email: email, password: password)
            }
        })
    }

    private func signIn(email: String, password: String) {
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                    self.presentErrorAlert(message: "Invalid Credentials")
                    
                case .success(let user):
                    print("Successfully logged in as user \(user)")
                    self.openRealmSync()
                    
                }
            }
        }
    }

    private func openRealmSync() {
        let user = app.currentUser!

        // The partition determines which subset of data to access.
        // Defines a default configuration so the realm being opened on other areas of the app is fetching the right partition
        Realm.Configuration.defaultConfiguration = user.configuration(partitionValue: user.id)

        Realm.asyncOpen() { (result) in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
                self.presentErrorAlert(message: "Oops! An error ocurred")

            case .success(_):
                // Realm opened
                self.performSegue(withIdentifier: "goToLaunchesVC", sender: nil)
            }
        }
    }
}

// MARK: - TextField Delegate
extension CreateAccountViewController: UITextFieldDelegate {
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
