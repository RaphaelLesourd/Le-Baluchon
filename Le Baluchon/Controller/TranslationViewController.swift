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
    private var originLanguage: Language? {
        didSet {
            guard let originLanguage = originLanguage else {return}
            translationView.languageChoiceView.originLanguageButton.setTitle(originLanguage.name,
                                                                             for: .normal)
        }
    }
    private var targetLanguage: Language? {
        didSet {
            guard let targetLanguage = targetLanguage else {return}
            translationView.languageChoiceView.targetLanguageButton.setTitle(targetLanguage.name,
                                                                             for: .normal)
        }
    }
    private var originText: String? {
        didSet {
            getTranslatedText()
        }
    }
    private var translation: Translation? {
        didSet {
            guard let translation = translation else {return}
            translationView.translatedLanguageView.textView.text = translation.data.translations[0].translatedText
        }
    }
    private var languageButtonTag: Int?
    // MARK: - Lifecycle

    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = translationView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    // MARK: - Lifecycle
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
        translationView.originLanguageView.clearButton.addTarget(self,
                                                                 action: #selector(clearAll),
                                                                 for: .touchUpInside)
        translationView.languageChoiceView.originLanguageButton.addTarget(self,
                                                                          action: #selector(displayLanguagesList(_:)),
                                                                          for: .touchUpInside)
        translationView.languageChoiceView.targetLanguageButton.addTarget(self,
                                                                          action: #selector(displayLanguagesList(_:)),
                                                                          for: .touchUpInside)
        translationView.languageChoiceView.languageDirectionButton.addTarget(self,
                                                                             action: #selector(swapLanguagebuttonTapped),
                                                                             for: .touchUpInside)
    }
    /// Adds a refreshed to the scrollView, trigger a neworl call to fetch latest exchange rate.
    private func setRefresherControl() {
        translationView.scrollView.refreshControl = translationView.refresherControl
        translationView.refresherControl.addTarget(self, action: #selector(getTranslatedText), for: .valueChanged)
    }

    private func setDefaultLanguages() {
        originLanguage = Language(language: "fr", name: "Français")
        targetLanguage = Language(language: "en", name: "Anglais")
    }

    /// Set all textView text property to nil to remove all text.
    @objc private func clearAll() {
        translationView.originLanguageView.textView.text = nil
        translationView.translatedLanguageView.textView.text = nil
    }

    // MARK: - Navigation
    /// Present a modal viewController with a list of all currencies available.
    /// - Parameter sender: Tapped UIButton
    @objc private func displayLanguagesList(_ sender: UIButton) {
        // set the UIbutton sender tag to the currencyButtonTag property to keep track which
        // button has been pushed.
        languageButtonTag = sender.tag
        // Instanciate the viewController to call.
        let languagesList = LanguagesListViewController()
        languagesList.languagesDelegate = self
        languagesList.addAutoLanguageOption = sender.tag == 0
        // Present the view controller modally.
        present(languagesList, animated: true, completion: nil)
    }

    // MARK: - API Call
    // translation request
    @objc private func getTranslatedText() {
        guard let originLanguage = originLanguage else {return}
        guard let targetLanguage = targetLanguage else {return}
        guard let text = originText, !text.isEmpty else {
            stopRefreshActivitycontrol()
            return
        }
        toggleActiviyIndicator(for: translationView.headerView.activityIndicator, shown: true)
        translationService.getTranslation(for: text,
                                          from: originLanguage.language,
                                          to: targetLanguage.language) { [weak self] result in
            guard let self = self else {return}
            self.stopRefreshActivitycontrol()

            switch result {
            case .success(let translatedText):
                self.translation = translatedText
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }

    private func stopRefreshActivitycontrol() {
        self.toggleActiviyIndicator(for: self.translationView.headerView.activityIndicator,
                                    shown: false)
        self.translationView.refresherControl.perform(#selector(UIRefreshControl.endRefreshing),
                                                      with: nil,
                                                      afterDelay: 0.05)
    }

    // MARK: - Languages swap
    @objc private func swapLanguagebuttonTapped() {
        let temporaryOriginalLanguage: Language?
        temporaryOriginalLanguage = originLanguage
        originLanguage = targetLanguage
        targetLanguage = temporaryOriginalLanguage
    }

}
// MARK: - Extensions
extension TranslationViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        // UITextView doesn't provide a callback when user hits the return key.
        // As a workaround, dismiss the keyboard when a new line character is detected.
        if text == "\n" {
            originText = textView.text
            textView.resignFirstResponder()
        }
        return true
    }
}

extension TranslationViewController: LanguagesListDelegate {

    func updateLanguage(with language: Language) {
        if languageButtonTag == 0 {
            originLanguage = language
        } else {
            targetLanguage = language
        }
        getTranslatedText()
    }
}
