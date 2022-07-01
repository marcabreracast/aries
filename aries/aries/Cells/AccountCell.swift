//
//  AccountCell.swift
//  aries
//
//  Created by Mar Cabrera on 01/07/2022.
//

import UIKit

class AccountCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    public func setup(title: String, isIconPresent: Bool) {
        titleLabel.text = title

        isIconPresent ? (icon.image = UIImage(systemName: "chevron.right")) : (icon.isHidden = true)
    }
}
