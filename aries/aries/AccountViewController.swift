//
//  AccountViewController.swift
//  aries
//
//  Created by Mar Cabrera on 25/05/2022.
//

import UIKit
import RealmSwift

enum CellType: Int, CaseIterable {
    case resetPassword = 1
    case logout = 2
}

class AccountViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    let realm = try! Realm()
    var user: User?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
    }

    // MARK: - Private Helpers

    private func logoutUser() {
        app.currentUser?.logOut(){ (_) in
            DispatchQueue.main.async {
                print("Logged out!")
                self.performSegue(withIdentifier: "goToLoginViewController", sender: nil)
            }
        }
    }

    private func resetPassword() {
        let email = app.currentUser?.profile.email ?? ""
        let client = app.emailPasswordAuth

        client.sendResetPasswordEmail(email) { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Reset password email not sent: \(error!.localizedDescription)")
                    return
                }

                print("Password reset email sent tp the following address: \(email)")

                // Present alert to notify user
                let alert = UIAlertController(title: "Reset Password", message: "An email has been sent. Please check your inbox and follow the next steps!", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell

        let cellType = CellType(rawValue: indexPath.row + 1)

        switch cellType {
        case .resetPassword:
            cell.setup(title: "Reset Password", isIconPresent: true)
        case .logout:
            cell.setup(title: "Logout", isIconPresent: false)
        case .none:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = CellType(rawValue: indexPath.row + 1)

        switch cellType {
        case .resetPassword:
            resetPassword()
        case .logout:
            logoutUser()
        case .none:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

