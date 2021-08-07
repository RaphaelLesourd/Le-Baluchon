//
//  RateMainView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import Foundation
import UIKit

class RateMainView: UIView {

    /// Initalise the view, and calls set up functions
    /// - Parameter frame: view frame set to .zero as it will be assigned to the UIViewController view frame.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollViewConstraints()
        setBackgroundImageConstraints()
        setupMainstackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let screenSizeWidth = UIScreen.main.bounds.width
    // MARK: - Scroll View

    /// Create a vertical scrollView and set its properties.
    private let scrollView: UIScrollView = {
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
    
    // MARK: - Background Image
    private let backgroundImage = BackgroundImage(image: #imageLiteral(resourceName: "rocketIcon"))

    private func setBackgroundImageConstraints() {
        contentView.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                                 constant: 10),
            backgroundImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            backgroundImage.heightAnchor.constraint(equalToConstant: screenSizeWidth * 1.3),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                     constant: -screenSizeWidth * 0.3)
        ])
    }

    // MARK: - Views
    let originCurrencyView: CurrencyEntryView = {
        let view = CurrencyEntryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return view
    }()

    let destinationCurrencyView: CurrencyEntryView = {
        let view = CurrencyEntryView()
        view.textfield.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return view
    }()

    let dataProviderLabel = FooterLabel(title: "Taux de change fournis par ifixer.io")

    // MARK: - Main StackView
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        // Create an array of the subviews to add to the stackView
        let mainStackSubViews: [UIView] = [originCurrencyView,
                                           destinationCurrencyView,
                                           dataProviderLabel
        ]
        // Iterate thru the subviews array to add them to the stak view
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        // Change spacing between certain view
        mainStackView.setCustomSpacing(10, after: destinationCurrencyView)
        // Add constraints for the mainstackView
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -16),
            mainStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                  multiplier: 0.99)
        ])
    }



}
