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
        let alert = UIAlertController(title: "Erreur!", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Fermer", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - ActivtyIndicator
    func toggleActiviyIndicator(for indicator: UIActivityIndicatorView, shown: Bool) {
        indicator.isHidden = !shown
        shown ? indicator.startAnimating() : indicator.stopAnimating()
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
