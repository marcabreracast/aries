//
//  UIImageView+Extension.swift
//  aries
//
//  Created by Mar Cabrera on 22/06/2022.
//

import Foundation
import UIKit

extension UIImageView {
    /**
     Function that makes asynchronous call and fetches an image from an URL
     */
    func setCustomImage(_ imgURLString: String?) {
        guard let imageURLString = imgURLString else {
            self.image = UIImage(named: "default.png")
            return
        }
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self?.image = data != nil ? UIImage(data: data!) : UIImage(named: "default.png")
            }
        }
    }
}
