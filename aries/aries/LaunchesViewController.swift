//
//  LaunchesViewController.swift
//  aries
//
//  Created by Mar Cabrera on 06/05/2022.
//

import UIKit
import Alamofire

class LaunchesViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var launches: [String] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        fetchLaunches()
    }

    public func fetchLaunches() {

        AF.request("https://api.spacexdata.com/v4/launches").responseDecodable(of: [Launch].self) { response in
            debugPrint("Response: \(response.description)")

            if let upcomingLaunches = response.value {
                for launch in upcomingLaunches {
                    self.launches.append(launch.name)
                }
                self.tableView.reloadData()
            }
        }
    }


}

// MARK: - Table View Delegate
extension LaunchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath) as! LaunchCell
        
        cell.nameLabel.text = launches[indexPath.row]
        return cell
    }
}

// MARK: - Table View Data Source
extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
}
 
