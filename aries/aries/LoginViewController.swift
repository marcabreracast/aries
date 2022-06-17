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
    @IBOutlet weak var createAccountLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.placeholder = "email@example.com"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        setCreateAccountLabel()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButton.showLoading()

        let email = "skroob@example.com"
        let password = "1234567"
    //    let email = emailTextfield.text ?? ""
     //   let password = passwordTextField.text ?? ""

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
    
    private func setCreateAccountLabel() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(createAccountLabelTapped(_:)))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(labelTap)
    }
    
    @objc func createAccountLabelTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToCreateAccount", sender: nil)
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
