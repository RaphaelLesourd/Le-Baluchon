//
//  UIViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

extension UIViewController {

    // MARK: - Alert
    func presentErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Fermer", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - ActivtyIndicator
    func toggleActiviyIndicator(for indicator: UIActivityIndicatorView,
                                and refresher: UIRefreshControl,
                                showing: Bool) {
        indicator.isHidden = !showing
        showing ? indicator.startAnimating() : indicator.stopAnimating()
        if showing == false {
            refresher.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.1)
        }
    }

    // MARK: - Keyboard
    func addKeyboardDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
            view.endEditing(true)
    }
}
