//
//  FavoriteLaunchCell.swift
//  aries
//
//  Created by Mar Cabrera on 22/06/2022.
//

import Foundation
import UIKit

class FavoriteLaunchCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rocketLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    func setup(model: UserLaunches) {
        self.nameLabel.text = model.name
        if let image = model.links?.image {
            self.imageView.setCustomImage(image)
        } else {
            self.imageView.image = UIImage(named: "no-image")
        }
        dateLabel.text = DateHelper.formatShortUnixDate(date: model.date_unix ?? 0.0)
        rocketLabel.text = model.rocket

    }
}
