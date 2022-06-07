//
//  LaunchInfoViewController.swift
//  aries
//
//  Created by Mar Cabrera on 23/05/2022.
//

import UIKit
import youtube_ios_player_helper
import RealmSwift

class LaunchInfoViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var playerStackView: UIStackView!
    
    // MARK: - Properties
    var launchInfo: UserLaunches?

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // MARK: - IBActions
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addFavoritesButtonTapped(_ sender: Any) {
        let realm = try! Realm()

        let user = realm.objects(User.self).first

        guard let user = realm.objects(User.self).first else { return }

        try! realm.write() {
         //   user.launches.append(launchInfo)
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
