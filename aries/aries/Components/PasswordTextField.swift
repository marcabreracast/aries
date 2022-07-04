//
//  PasswordTextField.swift
//  aries
//
//  Created by Mar Cabrera on 04/07/2022.
//

import Foundation
import UIKit

class PasswordTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.isSecureTextEntry = true

        // Add right icon functionality
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.tintColor = #colorLiteral(red: 0.9472092986, green: 0.912545681, blue: 0.8959150314, alpha: 1)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        self.rightView = button
        self.rightViewMode = .always
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }

    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let offset = 9
        let width  = 30
        let height = width
        let x = Int(bounds.width) - width - offset
        let y = offset
        let rightViewBounds = CGRect(x: x, y: y, width: width, height: height)
        return rightViewBounds
    }
}
