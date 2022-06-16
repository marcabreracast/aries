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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: LoadingButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.isSecureTextEntry = true
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
                    
                    self.performSegue(withIdentifier: "goToLaunchesVC", sender: nil)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
