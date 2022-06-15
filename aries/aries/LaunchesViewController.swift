//
//  LaunchesViewController.swift
//  aries
//
//  Created by Mar Cabrera on 06/05/2022.
//

import UIKit
import RealmSwift

class LaunchesViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var pastLaunches: [Launch] = []
    var upcomingLaunches: [Launch] = []
    var launches: Results<Launch>?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setNavBar()
        setTabBar()

        openPublicPartitionRealm()
    }


    
    // MARK: - Private Methods
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
    }

    private func setNavBar() {
        self.title = "Launches"
        self.tabBarController?.navigationItem.hidesBackButton = true // Don't know why this works instead of the navigation bar line
    }

    private func setTabBar() {
        self.tabBarController?.tabBar.tintColor = .white
        self.tabBarController?.tabBar.unselectedItemTintColor = .lightGray
    }
    
    /**
        We have to open a public Realm partition in order to get all the launches that were fetched from there
        The database fetches the launches from SpaceX API
     */
    private func openPublicPartitionRealm() {
        let user = app.currentUser!

        Realm.asyncOpen(configuration: user.configuration(partitionValue: "PUBLIC")) { (result) in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
                self.presentErrorAlert(message: "Oops! An error ocurred")

            case .success(let realm):

                self.launches = realm.objects(Launch.self)
                self.populateTableView()
            }
        }
    }

    /**
        Function that filters between upcoming and past launches and populates data coming from Realm database
     */
    private func populateTableView() {
        if let launches = self.launches {
            for launch in launches {
                if launch.upcoming ?? false {
                    self.upcomingLaunches.append(launch)
                } else {
                    self.pastLaunches.append(launch)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func segmentedControlTapped(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send launch info here to Launch Info VC
        if let vc = segue.destination as? LaunchInfoViewController, let launchInfo = sender as? Launch {
            // We need to transform the data as UserLaunches for the private user partition, otherwise the schemas won't work well
            vc.launchInfo = UserLaunches(id: launchInfo.id, dateUnix: launchInfo.date_unix, details: launchInfo.details, name: launchInfo.name, upcoming: launchInfo.upcoming, links: nil, launchpad: launchInfo.launchpad)
        }
    }
}

// MARK: - Table View Delegate
extension LaunchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath) as! LaunchCell
        cell.selectionStyle = .none
        
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
 
