//
//  FavoriteLaunchCell.swift
//  aries
//
//  Created by Mar Cabrera on 22/06/2022.
//

import Foundation
import UIKit

class FavoriteLaunchCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    func setup(model: UserLaunches) {
        self.label.text = model.name
    }
}
