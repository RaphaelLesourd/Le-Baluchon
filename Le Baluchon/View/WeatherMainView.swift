//
//  WeatherMainView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import Foundation
import UIKit

enum SearchBarHeight: CGFloat {
    case collapsed = 0
    case expanded = 50
}

class WeatherMainView: UIView {

    // MARK: - Initialiser
    /// Initalise the view, and calls set up functions
    /// - Parameter frame: view frame set to .zero as it will be assigned to the UIViewController view frame.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupScrollViewConstraints()
        setupMainstackView()
        setOriginWeatherViewHeight()
        setDestinationWeatherInfoViewHeight()
        setSearchBarHeight()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var searchBarHeightConstraint = NSLayoutConstraint()
    // MARK: - Subviews
    let refresherControl = Refresher(frame: .zero)

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

    let localWeatherView = LocalWeatherView()
    let destinationWeatherView = DestinationWeatherView()
    let destinationWeatherInfoView = DestinationWeatherInfoView()
    private let dataProviderLabel = LegendLabel(title: "Météo par OpenWeatherMap")

    let headerView: HeaderView = {
        let view = HeaderView()
        view.titleLabel.text = "Météo"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return view
    }()

    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        bar.backgroundColor = .clear
        bar.searchTextField.tintColor = .label
        bar.autocapitalizationType = .words
        bar.autocorrectionType = .no
        bar.enablesReturnKeyAutomatically = true
        bar.returnKeyType = .done
        bar.textContentType = .none
        bar.placeholder = "Recherchez"
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

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
extension WeatherMainView {
    /// Add the scrollView to  RateMainView  as a subview.
    /// Add the contentView to the scrollView as a subView.
    /// Set constraints to respect safeArea guides.
    private func setupScrollViewConstraints() {
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

    private func setSearchBarHeight() {
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: SearchBarHeight.collapsed.rawValue)
        searchBarHeightConstraint.isActive = true
    }

    private func setOriginWeatherViewHeight() {
        localWeatherView.translatesAutoresizingMaskIntoConstraints = false
        localWeatherView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setDestinationWeatherInfoViewHeight() {
        destinationWeatherInfoView.translatesAutoresizingMaskIntoConstraints = false
        destinationWeatherInfoView.heightAnchor.constraint(equalToConstant: 235).isActive = true
    }
    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        // Create an array of the subviews to add to the stackView
        let mainStackSubViews: [UIView] = [headerView,
                                           localWeatherView,
                                           searchBar,
                                           destinationWeatherView,
                                           destinationWeatherInfoView,
                                           dataProviderLabel
        ]
        // Iterate thru the subviews array to add them to the stak view
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        // Add constraints for the mainstackView
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -16),
            mainStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                  multiplier: 0.96)
        ])
    }
}
