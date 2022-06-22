//
//  LaunchInfoViewController.swift
//  aries
//
//  Created by Mar Cabrera on 23/05/2022.
//

import UIKit
import youtube_ios_player_helper
import RealmSwift
import Alamofire
import MapKit

class LaunchInfoViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var thirdPartyStackView: UIStackView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties
    var launchInfo: Launch?
    let realm = try! Realm()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        dateView.layer.cornerRadius = 10

        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 10

        playerView.layer.masksToBounds = true
        playerView.layer.cornerRadius = 10

        user = realm.objects(User.self).first

        populateLaunchInfoFields()
        fetchLaunchpadInfo()
    }

    // MARK: - Private Helpers
    private func populateLaunchInfoFields() {
        guard let launchInfo = launchInfo else {
            return
        }

        nameLabel.text = launchInfo.name

        dateLabel.text = DateHelper.formatShortUnixDate(date: launchInfo.date_unix ?? 0.0)

        if let launchDetails = launchInfo.details {
            detailsLabel.text = launchDetails
        } else {
            detailsLabel.text = "There are not details available for this launch."
        }

        if let youtubeId = launchInfo.links?.youtube_id {
            playerView.load(withVideoId: youtubeId)
        } else {
            playerView.isHidden = true
        }

        // Checks if the launch is on favorites, and if it is then fills the favorite star button
        if user?.launches.contains(where: {$0.id == launchInfo.id}) ?? false {
            favoriteButton.flipFavoritedState(true)
        }
    }

    private func fetchLaunchpadInfo() {
        guard let launchpadId  = launchInfo?.launchpad else { return }

        AF.request("https://api.spacexdata.com/v4/launchpads/\(launchpadId)").responseDecodable(of: Launchpad.self) { response in
            debugPrint("Response: \(response.description)")

            if let response = response.value {
                // Default coordinates: Dublin (because why not having launches here)
                let initialLocation = CLLocation(latitude: response.latitude ?? 53.350140, longitude: response.longitude ?? -6.266155)

                self.mapView.centerToLocation(initialLocation)

                self.setMapAnnotation(launchpadInfo: response)
            }
        }
    }

    /**
     Function that sets pin on map to make launchpad visible
     */
    private func setMapAnnotation(launchpadInfo: Launchpad) {
        let coordinates = CLLocationCoordinate2D(latitude: launchpadInfo.latitude ?? 0.0, longitude: launchpadInfo.longitude ?? 0.0)
        let launchpadLocation = LaunchpadLocation(title: launchpadInfo.fullName ?? "", coordinate: coordinates, info: launchpadInfo.details ?? "")
        launchpadLocation.title = launchpadInfo.fullName ?? ""
        self.mapView.addAnnotation(launchpadLocation)
    }

    // MARK: - IBActions
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func addFavoritesButtonTapped(_ sender: Any) {

        guard let user = user, let launchInfo = launchInfo else {
            return
        }

        // If the launch is not included in the user's favorites we add it
        if !user.launches.contains(where: {$0.id == launchInfo.id}) {
            // We have to create a new UserLaunches object to be able to conform to User schema
            // Data from launches is of Launch type
            let links = LaunchLinks()
            links.image = launchInfo.links?.patch?.small
            let favoriteLaunch = UserLaunches(id: launchInfo.id, dateUnix: launchInfo.date_unix, details: launchInfo.details, name: launchInfo.name, upcoming: launchInfo.upcoming, links: links, launchpad: launchInfo.launchpad)

            try! realm.write() {
                // In order to add objects to the database we need to use the copy of it, otherwise it'll cause issues
                if let launchCopy = favoriteLaunch.copy {
                    user.launches.append(launchCopy)
                }
            }
            favoriteButton.flipFavoritedState(true)
        } else {
            // Otherwise we remove it from the array
            try! realm.write() {
                if let index = user.launches.firstIndex(where: { $0.id == launchInfo.id }) {
                    user.launches.remove(at: index)
                }
            }
            favoriteButton.flipFavoritedState(false)
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

/**
    In order to create Annotations we need a class to conform to MKAnnotation protocol and that it also inherits from NSObject
 */
class LaunchpadLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
