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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var pastLaunches: [Launch] = []
    var upcomingLaunches: [Launch] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white

        self.title = "Launches"

        fetchLaunches()
    }

    // MARK: - Private Methods
    public func fetchLaunches() {
        // Better to take request call out of this screen to make it more reusable
        AF.request("https://api.spacexdata.com/v4/launches").responseDecodable(of: [Launch].self) { response in
            debugPrint("Response: \(response.description)")

            if let launches = response.value {
                for launch in launches {
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
    
    // MARK: - IBActions
    @IBAction func segmentedControlTapped(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send launch info here to Launch Info VC
        if let vc = segue.destination as? LaunchInfoViewController, let launchInfo = sender as? Launch {
            vc.launchInfo = launchInfo
        }
    }
}

// MARK: - Table View Delegate
extension LaunchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath) as! LaunchCell
        cell.selectionStyle = .none
g
        let selectedIndex = self.segmentedControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            cell.setup(model: upcomingLaunches[indexPath.row])
        case 1:
            cell.setup(model: pastLaunches[indexPath.row])
        default:
            break
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We have to make sure that depending on the section of the segmented control selected, the info
        // can come from the upcoming or past arraysgi
        let selectedIndex = self.segmentedControl.selectedSegmentIndex
        var launch: Launch?

        switch selectedIndex {
        case 0:
            launch = upcomingLaunches[indexPath.row]
        case 1:
            launch = pastLaunches[indexPath.row]
        default:
            break
        }

        performSegue(withIdentifier: "goToLaunchInfo", sender: launch)
    }
}

// MARK: - Table View Data Source
extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedIndex = self.segmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            return upcomingLaunches.count
        case 1:
            return pastLaunches.count
        default:
            return 0
        }
    }
}
 
