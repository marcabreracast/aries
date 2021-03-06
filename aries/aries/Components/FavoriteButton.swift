//
//  FavoriteButton.swift
//  aries
//
//  Created by Mar Cabrera on 08/06/2022.
//

import Foundation
import UIKit

class FavoriteButton: UIButton {
    // MARK: - Properties
    private let unfavoritedImage = UIImage(systemName: "star")
    private let favoritedImage = UIImage(systemName: "star.fill")?.withTintColor(#colorLiteral(red: 0.9389871955, green: 0.7823597789, blue: 0.5454313159, alpha: 1), renderingMode: .alwaysOriginal)
    private var isFavorite = false

    // MARK: - Public Functions
    func flipFavoritedState(_ state: Bool) {
        isFavorite = state
        animate()
    }

    // MARK: - Private Helpers
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isFavorite ? self.favoritedImage : self.unfavoritedImage
            self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
            self.setImage(newImage, for: .normal)
            self.isFavorite = !self.isFavorite

        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
