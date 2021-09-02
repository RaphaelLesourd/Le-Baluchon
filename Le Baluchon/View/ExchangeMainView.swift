//
//  RateMainView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import Foundation
import UIKit

class ExchangeMainView: UIView {

    // MARK: - Initialiser
    /// Initalise the view, and calls set up functions
    /// - Parameter frame: view frame set to .zero as it will be assigned to the UIViewController view frame.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollViewConstraints()
        setBackgroundImageConstraints()
        setDailyRateViewConstraits()
        setupMainstackView()
        setCurrencySwapButtonConstaints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    private let backgroundImage = BackgroundImage(imageName: "exchangeBackgroundImage")
    let refresherControl = Refresher(frame: .zero)
    let dailyRateView = DailyRateView()

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

    let headerView: HeaderView = {
        let view = HeaderView()
        view.titleLabel.text = "Taux de change"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return view
    }()

    let originCurrencyView: CurrencyEntryView = {
        let view = CurrencyEntryView()
        view.currencyButton.tag = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return view
    }()

    let targetCurrencyView: CurrencyEntryView = {
        let view = CurrencyEntryView()
        view.currencyButton.tag = 1
        view.textfield.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return view
    }()

    private let dataProviderLabel = LegendLabel(title: "Taux de change par fixer.io")

    let currencySwapButton: UIButton = {
        let btn = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .black, scale: .large)
        let buttonImage = UIImage(systemName: "arrow.up.arrow.down.circle.fill",
                                  withConfiguration: imageConfig)
        btn.setImage(buttonImage, for: .normal)
        btn.tintColor = .systemPink
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

// MARK: - Constraints
extension ExchangeMainView {
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

        let screenSizeHeight = UIScreen.main.bounds.height
        NSLayoutConstraint.activate([
            backgroundImage.heightAnchor.constraint(equalToConstant: screenSizeHeight * 0.51),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -80)
        ])
    }

    private func setDailyRateViewConstraits() {
        dailyRateView.translatesAutoresizingMaskIntoConstraints = false
        dailyRateView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    private func setCurrencySwapButtonConstaints() {
        contentView.addSubview(currencySwapButton)
        NSLayoutConstraint.activate([
            currencySwapButton.topAnchor.constraint(equalTo: originCurrencyView.bottomAnchor,
                                                    constant: -15),
            currencySwapButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            currencySwapButton.heightAnchor.constraint(equalToConstant: 60),
            currencySwapButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [headerView,
                                           originCurrencyView,
                                           targetCurrencyView,
                                           dailyRateView,
                                           dataProviderLabel
        ]
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        mainStackView.setCustomSpacing(10, after: dailyRateView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -16),
            mainStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                  multiplier: 0.99)
        ])
    }
}
