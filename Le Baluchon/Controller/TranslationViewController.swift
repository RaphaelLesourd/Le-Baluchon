//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class TranslationViewController: UIViewController {

    // MARK: - Properties
    let translationView = TranslationMainView()
    // MARK: - Lifecycle

    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = translationView
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupView()
        setButtonTarget()
        addKeyboardDismissGesture()
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .viewControllerBackgroundColor
        translationView.updateLangues(with: "Français", translated: "Anglais")
    }

    private func setDelegates() {
        translationView.originLanguageView.textView.delegate = self
        translationView.translatedLanguageView.textView.delegate = self
    }

    private func setButtonTarget() {
        translationView.originLanguageView.clearButton.addTarget(self,
                                                                 action: #selector(clearAll),
                                                                 for: .touchUpInside)
    }

    // MARK: - Button Targets
    /// Set all textView text property to nil to remove all text.
    @objc private func clearAll() {
        translationView.originLanguageView.textView.text = nil
        translationView.translatedLanguageView.textView.text = nil
    }
}

// MARK: - Extensions
extension TranslationViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        // UITextView doesn't provide a callback when user hits the return key. As a workaround, dismiss the keyboard when a new line character is detected.
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
