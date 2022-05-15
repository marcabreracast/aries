//
//  LaunchCell.swift
//  aries
//
//  Created by Mar Cabrera on 06/05/2022.
//

import Foundation
import UIKit

class LaunchCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - Methods
    func setup(model: Launch) {
        nameLabel.text = model.name
    }
    
    
    
}
