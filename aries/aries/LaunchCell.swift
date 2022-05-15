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
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    var isFavorite: Bool = false
    
    // MARK: - Methods
    func setup(model: Launch) {
        nameLabel.text = model.name
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favoriteButton.isSelected ? favoriteButton.setBackgroundImage(UIImage(named: "star"), for: .selected) : favoriteButton.setBackgroundImage(UIImage(named: "start.fill"), for: .normal)
    }
    
    
    
}
