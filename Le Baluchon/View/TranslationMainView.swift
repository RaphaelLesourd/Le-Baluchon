//
//  TranslationMainView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import Foundation
import UIKit

class TranslationMainView: UIView {

    // MARK: - Initialiser
    /// Initalise the view, and calls set up functions
    /// - Parameter frame: view frame set to .zero as it will be assigned to the UIViewController view frame.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollViewConstraints()
        setBackgroundImageConstraints()
        setupMainstackView()
        setupLanguageViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let screenSize = UIScreen.main.bounds
    
    // MARK: - Subviews
    /// Create a vertical scrollView and set its properties.
    let scrollView: UIScrollView = {
        let scv = UIScrollView()
        scv.alwaysBounceVertical = true
        scv.alwaysBounceHorizontal = false
        scv.showsVerticalScrollIndicator = false
        scv.showsVerticalScrollIndicator = false
        scv.translatesAutoresizingMaskIntoConstraints = false
        return scv
    }()

    /// Create the contentView in the scrollView that will contain all the UI elements.
    private let contentView: UIView = {
        let uiv = UIView()
        uiv.backgroundColor = .clear
        uiv.translatesAutoresizingMaskIntoConstraints = false
        return uiv
    }()

    private let backgroundImage = BackgroundImage(image: #imageLiteral(resourceName: "translateIcon"))
    let refresherControl = Refresher(frame: .zero)

    let headerView: HeaderView = {
        let view = HeaderView()
        view.titleLabel.text = "Traduction"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return view
    }()

    let languageChoiceView = LanguageChoicesView()
    let originLanguageView = LanguageTextView(isEditable: true)
    let translatedLanguageView = LanguageTextView(isEditable: false)

    private let dataProviderLabel = LegendLabel(title: "Traduction par Google Translate")

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

// MARK: - Constraints
extension TranslationMainView {
    /// Add the scrollView to  RateMainView  as a subview.
    /// Add the contentView to the scrollView as a subView.
    /// Set constraints to respect safeArea guides.
    private func setScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setBackgroundImageConstraints() {
        contentView.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImage.widthAnchor.constraint(equalToConstant: screenSize.width),
            backgroundImage.heightAnchor.constraint(equalToConstant: screenSize.width),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                     constant: -screenSize.width * 0.3)
        ])
    }

    private func setupLanguageViews() {
        originLanguageView.translatesAutoresizingMaskIntoConstraints = false
        originLanguageView
            .heightAnchor
            .constraint(equalToConstant: screenSize.height * 0.25)
            .isActive = true

        translatedLanguageView.translatesAutoresizingMaskIntoConstraints = false
        translatedLanguageView
            .heightAnchor
            .constraint(equalToConstant: screenSize.height * 0.25)
            .isActive = true
    }

    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        // Create an array of the subviews to add to the stackView
        let mainStackSubViews: [UIView] = [headerView,
                                           languageChoiceView,
                                           originLanguageView,
                                           translatedLanguageView,
                                           dataProviderLabel
        ]
        // Iterate thru the subviews array to add them to the stak view
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        // Change spacing between certain view
        mainStackView.setCustomSpacing(30, after: headerView)
        mainStackView.setCustomSpacing(30, after: originLanguageView)
        // Add constraints for the mainstackView
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -16),
            mainStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                  multiplier: 0.95)
        ])
    }
}
