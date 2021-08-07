//
//  UIViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

extension UIViewController {

    func addKeyboardDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
