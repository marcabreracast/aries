//
//  ResetPasswordViewController.swift
//  aries
//
//  Created by Mar Cabrera on 06/07/2022.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmButton: LoadingButton!

    // MARK: - Properties
    var token: String?
    var tokenId: String?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
    }

    // MARK: - Private Helpers
    private func resetPassword() {

        let password = confirmPasswordTextField.text ?? ""

        app.emailPasswordAuth.resetPassword(to: password, token: token ?? "", tokenId: tokenId ?? "") { (error) in
            DispatchQueue.main.async {
                self.confirmButton.hideLoading()
                guard error == nil else {
                    print("Failed to reset password: \(error!.localizedDescription)")
                    self.presentErrorAlert(message: "There was an error resetting the password")
                    // Should do something here
                    return
                }
                print("Successfully reset password")
                self.presentSuccessAlert()
            }
        }
    }

    private func presentSuccessAlert() {
        let alert = UIAlertController(title: "Reset Password", message: "Your password was reset successfully", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            // If user is logged in then we continue in app, if not it's redirected to Login
            if let _ = app.currentUser {
                self.performSegue(withIdentifier: "goToLaunchesViewController", sender: nil)
            } else {
                self.performSegue(withIdentifier: "goToLoginViewController", sender: nil)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if passwordTextField.text != confirmPasswordTextField.text {
            errorLabel.isHidden = false
            errorLabel.text = "Passwords do not match"
        } else {
            confirmButton.showLoading()
            errorLabel.isHidden = true
            resetPassword()
        }
    }
}
