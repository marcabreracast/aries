//
//  FavoritesViewController.swift
//  aries
//
//  Created by Mar Cabrera on 23/06/2022.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    let realm = try! Realm()
    var user: User?
    lazy var favoriteLaunches: List<UserLaunches>? = nil
    var notificationToken: NotificationToken?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        setCollectionView()

        // Fetch favorite launches from the database
        openPrivatePartitionRealm()
    }

    deinit {
        // Invalidate notificationToken
        notificationToken?.invalidate()
    }

    // MARK: - Private Helper Methods
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
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

    // Observe the favorites for changes. When changes are received, collectionView is updated
    private func addFavoritesListener() {
        notificationToken = favoriteLaunches?.observe { [weak self] (changes) in
            guard let collectionView = self?.collectionView else { return }

            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed so we need to apply the to the collectionView
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}

// MARK: - Collection View Delegate

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteLaunches?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let favoriteLaunches = favoriteLaunches else {
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteLaunchesCell", for: indexPath) as! FavoriteLaunchCell

        cell.setup(model: favoriteLaunches[indexPath.row])

        cell.layer.cornerRadius = 10

        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow = 1
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfCellsInRow))

        return CGSize(width: size, height: 90)
    }
}


