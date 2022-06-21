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
    var notificationToken: NotificationToken?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        setTableView()

        // Fetch favorite launches from the database
        openPrivatePartitionRealm()
    }

    deinit {
        // Invalidate notificationToken
        notificationToken?.invalidate()
    }
    
    private func openPrivatePartitionRealm() {
        let user = app.currentUser!

        // The partition determines which subset of data to access.
        // Defines a default configuration so the realm being opened on other areas of the app is fetching the right partition
        Realm.Configuration.defaultConfiguration = user.configuration(partitionValue: user.id)

        Realm.asyncOpen() { (result) in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
                self.presentErrorAlert(message: "Oops! An error ocurred")

            case .success(let realm):
                print("Private Partition Realm Opened")
                let result = realm.objects(User.self).first
                self.favoriteLaunches = result?.launches
                
                self.addFavoritesListener()
            }
        }
    }

    // MARK: - Private Helpers
    private func setTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
    }

    // Observe the favorites for changes. When changes are received, tableView is updated
    private func addFavoritesListener() {
        notificationToken = favoriteLaunches?.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }

            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed so we need to apply the to the tableView
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                        with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                        with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                        with: .automatic)
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

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
