//
//  CheckYourEmailViewController.swift
//  aries
//
//  Created by Mar Cabrera on 11/07/2022.
//

import UIKit

class CheckYourEmailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
q
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true

        let logoImage = UIImage(named: "email-rocket")?.withTintColor(#colorLiteral(red: 0.9472092986, green: 0.912545681, blue: 0.8959150314, alpha: 1))
        imageView.image = logoImage
    }
}
