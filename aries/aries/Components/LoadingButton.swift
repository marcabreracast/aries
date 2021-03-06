//
//  LoadingButton.swift
//  aries
//
//  Created by Mar Cabrera on 25/05/2022.
//

import Foundation
import UIKit

/**
    This is a custom button that includes a loading indicator
 */
class LoadingButton: UIButton {
    // MARK: - Properties
    private var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!

    // MARK: - Init Method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        self.titleLabel?.font = UIFont(name: "Oxanium-Regular", size: 17)
        self.layer.cornerRadius = 5
        self.backgroundColor = #colorLiteral(red: 0.6060286164, green: 0.5469256043, blue: 0.5953031778, alpha: 1)
    }

    // MARK: - Helper Methods
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)

        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    // MARK: - Private Methods
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray

        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
