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
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    let realm = try! Realm()
    var user: User?
    lazy var favoriteLaunches: List<UserLaunches>? = nil

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white

        // Fetch favorite launches from the database
        user = realm.objects(User.self).first

        favoriteLaunches = user?.launches
    }

    // MARK: - IBActions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logoutButton.showLoading()
        app.currentUser?.logOut(){ (_) in
            DispatchQueue.main.async {
                print("Logged out!")
                self.logoutButton.hideLoading()
                self.navigationController?.popViewController(animated: true)
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

// MARK: - TableView Delegate
extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteLaunchCell", for: indexPath) as! FavoriteLaunchCell

        cell.title.text = favoriteLaunches?[indexPath.row].name
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - TableView Data Source
extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLaunches?.count ?? 0
    }
}

class FavoriteLaunchCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
}
