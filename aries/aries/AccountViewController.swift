//
//  AccountViewController.swift
//  aries
//
//  Created by Mar Cabrera on 25/05/2022.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var logoutButton: LoadingButton!

    // MARK: - Properties
    let realm = try! Realm()
    var user: User?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Private Helpers


    // MARK: - IBActions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logoutButton.showLoading()
        app.currentUser?.logOut(){ (_) in
            DispatchQueue.main.async {
                print("Logged out!")
                self.logoutButton.hideLoading()
                self.performSegue(withIdentifier: "goToLoginViewController", sender: nil)
            }
        }
    }
}

