//
//  LaunchInfoViewController.swift
//  aries
//
//  Created by Mar Cabrera on 23/05/2022.
//

import UIKit

class LaunchInfoViewController: UIViewController {
    // MARK: - IBOutlets

    // MARK: - Properties
    var launchInfo: Launch?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = launchInfo?.name

        // Do any additional setup after loading the view.
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
