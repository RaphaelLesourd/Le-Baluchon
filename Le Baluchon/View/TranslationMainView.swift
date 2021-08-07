//
//  TranslationMainView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import Foundation
import UIKit

class TranslationMainView: UIView {
    
    /// Initalise the view, and calls set up functions
    /// - Parameter frame: view frame set to .zero as it will be assigned to the UIViewController view frame.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollViewConstraints()
        setBackgroundImageConstraints()
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
    private let backgroundImage = BackgroundImage(image: #imageLiteral(resourceName: "translateIcon"))

    private func setBackgroundImageConstraints() {
        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                 constant: 20),
            backgroundImage.widthAnchor.constraint(equalToConstant: screenSizeWidth),
            backgroundImage.heightAnchor.constraint(equalToConstant: screenSizeWidth * 0.8),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: -screenSizeWidth * 0.3)
        ])
    }
}
