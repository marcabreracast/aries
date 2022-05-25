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
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: LoadingButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.placeholder = "email@example.com"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
    }
    
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButton.showLoading()
        let email = emailTextfield.text ?? ""
        let password = passwordTextField.text ?? ""
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            DispatchQueue.main.async {
                self.loginButton.hideLoading()
                switch result {
                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                    self.presentErrorAlert()

                case .success(let user):
                    print("Successfully logged in as user \(user)")
                    self.performSegue(withIdentifier: "goToLaunches", sender: nil)
                }

            }
        }
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Invalid credentials", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
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
