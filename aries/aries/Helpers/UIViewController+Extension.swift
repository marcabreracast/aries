//
//  UIViewController+Extension.swift
//  aries
//
//  Created by Mar Cabrera on 01/06/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}
