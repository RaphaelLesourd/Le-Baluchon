//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class TranslationViewController: UIViewController {

    // MARK: - Properties
    private let translationView = TranslationMainView()
    private let translationService = TranslationService()
    /// Orgin language Property
    private var originLanguage: Language? {
        didSet {
            guard let originLanguage = originLanguage else {return}
            translationView.languageChoiceView.originLanguageButton
                .setTitle(originLanguage.name, for: .normal)
        }
    }
    /// traget translated language Property
    private var targetLanguage: Language? {
        didSet {
            guard let targetLanguage = targetLanguage else {return}
            translationView.languageChoiceView.targetLanguageButton
                .setTitle(targetLanguage.name, for: .normal)
        }
    }
    private var originText: String?
    private var tappedLanguageButtonTag: Int?

    // MARK: - Lifecycle
    override func loadView() {
        view = translationView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setDefaultLanguages()
        setButtonTarget()
        setRefresherControl()
        addKeyboardDismissGesture()
    }

    // MARK: - Setup
    private func setDelegates() {
        translationView.originLanguageView.textView.delegate = self
        translationView.translatedLanguageView.textView.delegate = self
    }

    private func setButtonTarget() {
        translationView.originLanguageView.clearButton
            .addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        translationView.languageChoiceView.originLanguageButton
            .addTarget(self, action: #selector(displayLanguagesList(_:)), for: .touchUpInside)
        translationView.languageChoiceView.targetLanguageButton
            .addTarget(self, action: #selector(displayLanguagesList(_:)), for: .touchUpInside)
        translationView.languageChoiceView.languageDirectionButton
            .addTarget(self, action: #selector(swapLanguagebuttonTapped), for: .touchUpInside)
    }
    /// Adds a refreshed to the scrollView, trigger a neworl call to fetch latest exchange rate.
    private func setRefresherControl() {
        translationView.scrollView.refreshControl = translationView.refresherControl
        translationView.refresherControl
            .addTarget(self, action: #selector(getTranslatedText), for: .valueChanged)
    }

    /// Default languages when the app is first open
    private func setDefaultLanguages() {
        originLanguage = Language(language: "fr", name: "Français")
        targetLanguage = Language(language: "en", name: "Anglais")
    }

    // MARK: - API Call
    /// Request translation from Api then call function to display result or display a error.
    /// - Note: Unwarps originLanguage, targetLanguage, text optionals and check
    ///  if text to be translated is empty before making api request.
    @objc private func getTranslatedText() {
        guard let originLanguage = originLanguage, let targetLanguage = targetLanguage else {return}
        guard let text = originText, !text.isEmpty else {
            return displayRefresherActivityControls(false)
        }
        displayRefresherActivityControls(true)
        translationService.getTranslation(for: text,
                                          from: originLanguage.language,
                                          to: targetLanguage.language) { [weak self] result in
            guard let self = self else {return}
            self.displayRefresherActivityControls(false)
            switch result {
            case .success(let translatedText):
                self.updateTranslatedView(with: translatedText)
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }
    /// Show/start or hide/stop activity control
    /// - Parameter status: Bool to set if activity control should be displayed or not
    private func displayRefresherActivityControls(_ status: Bool) {
        toggleActiviyIndicator(for: translationView.headerView.activityIndicator,
                               and: translationView.refresherControl,
                               showing: status)
    }

    // MARK: - Languages swap

    /// Swap chosen orgin and target languages.
    /// - Note: If the orginLanguage is set to Auto (value = "") then present error alert.
    @objc private func swapLanguagebuttonTapped() {
        guard originLanguage?.language != "" else {
            return presentErrorAlert(with: "Le language de destination ne peux être mis en auto.")
        }
        let temporaryOriginalLanguage = originLanguage
        originLanguage = targetLanguage
        targetLanguage = temporaryOriginalLanguage
    }

    // MARK: - Update views
    private func updateTranslatedView(with translation: Translation) {
        let text = translation.data.translations[0].translatedText
        self.translationView.translatedLanguageView.textView.text = text
    }

    /// Set all textView text property to nil to remove all text.
    @objc private func clearAll() {
        translationView.originLanguageView.placeholderLabel.isHidden = false
        translationView.originLanguageView.textView.text = nil
        translationView.translatedLanguageView.textView.text = nil
        originText = nil
    }

    // MARK: - Languages List
    /// Present a modal viewController with a list of all currencies available.
    /// - Note: Sender tag property sets the currencyButtonTag property to keep track which
    /// button has been tapped.
    /// - Parameter sender: Tapped UIButton
    @objc private func displayLanguagesList(_ sender: UIButton) {
        tappedLanguageButtonTag = sender.tag
        let languagesList = LanguagesListViewController()
        languagesList.languagesDelegate = self
        languagesList.addAutoLanguageOption = sender.tag == 0
        present(languagesList, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension TranslationViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        // UITextView doesn't provide a callback when user hits the keyboard return key.
        // As a workaround, dismiss the keyboard when a new line character is detected.
        if text == "\n" {
            originText = textView.text
            getTranslatedText()
            textView.resignFirstResponder()
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == translationView.originLanguageView.textView {
            translationView.originLanguageView.placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
}

extension TranslationViewController: LanguagesListDelegate {

    /// Set the  orgin language or target language with the Language object
    /// passed thru the LanguaguesListDelegate protocol.
    /// Then request for a new translation.
    /// - Parameter language: Languague object
    func updateLanguage(with language: Language) {
        if tappedLanguageButtonTag == 0 {
            originLanguage = language
        } else {
            targetLanguage = language
        }
        getTranslatedText()
    }
}
