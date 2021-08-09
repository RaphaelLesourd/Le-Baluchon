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
    @objc private func clearAll() {
        translationView.originLanguageView.textView.text = nil
        translationView.translatedLanguageView.textView.text = nil
    }
}

extension TranslationViewController: UITextViewDelegate {


}
