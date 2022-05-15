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
    var launches: [Launch] = [] // This will be removed once the filtering is implementes
    var pastLaunches: [Launch] = []
    var upcomingLaunches: [Launch] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        fetchLaunches()
    }

    public func fetchLaunches() {

        AF.request("https://api.spacexdata.com/v4/launches").responseDecodable(of: [Launch].self) { response in
         //   debugPrint("Response: \(response.description)")

            if let launches = response.value {
                for launch in launches {
                    self.launches.append(launch)
                    let launchDate = DateHelper.formatISODate(date: launch.dateLocal)
                    
                    if launch.upcoming {
                        self.upcomingLaunches.append(launch)
                    } else {
                        self.pastLaunches.append(launch)
                    }

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
        cell.setup(model: launches[indexPath.row])
        
        return cell
    }
}

// MARK: - Table View Data Source
extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
}
 
