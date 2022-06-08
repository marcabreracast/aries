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
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var playerStackView: UIStackView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties
    var launchInfo: UserLaunches?

    override func viewDidLoad() {
        super.viewDidLoad()

        setLaunchInfo()
        fetchLaunchPadInfo()
    }

    // MARK: - Private Helpers
    private func setLaunchInfo() {
        guard let launchInfo = launchInfo else {
            return
        }

        nameLabel.text = launchInfo.name

        if let launchDetails = launchInfo.details {
            detailsLabel.text = launchDetails
        } else {
            detailsLabel.text = "There are not details available for this launch."
        }

        playerView.layer.cornerRadius = 10

        if let youtubeId = launchInfo.links?.youtubeId {
            playerView.load(withVideoId: youtubeId)
        } else {
            playerStackView.isHidden = true
            playerView.backgroundColor = .black
        }
    }

    private func fetchLaunchPadInfo() {
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

        self.mapView.addAnnotation(launchpadLocation)
    }

    // MARK: - IBActions
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func addFavoritesButtonTapped(_ sender: Any) {
        favoriteButton.flipFavoritedState()

        let realm = try! Realm()
        guard let user = realm.objects(User.self).first, let launchInfo = launchInfo else {
            return
        }

        // If the launch is not included in the user's favorites we add it
        if !user.launches.contains(where: {$0.id == launchInfo.id}) {
            try! realm.write() {
                user.launches.append(launchInfo)
            }
        } else {
            // Otherwise we remove it from the array
            try! realm.write() {
                if let index = user.launches.firstIndex(where: { $0.id == launchInfo.id }) {
                    user.launches.remove(at: index)
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

/**
    In order to create Annotations we need a class to conform to MKAnnotation protocol and that it also inherits from NSObject
 */
class LaunchpadLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?
q
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
