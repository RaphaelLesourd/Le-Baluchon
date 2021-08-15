//
//  LanguagesListViewController.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import UIKit

protocol LanguagesListDelegate: AnyObject {
    func updateLanguage(with currency: Language)
}

class LanguagesListViewController: UIViewController {

    weak var languagesDelegate: LanguagesListDelegate?
    private let languagesListView = LanguagesListView()
    /// Initialise an empty array of type Currencies to use as a full list of currencies.
    /// - Stores the full list of currencies and copy  it to the filtered currency list array when set.
    private var languageList: [Language] = [] {
        didSet{
            filteredLanguageList = languageList
        }
    }
    /// Initialise an empty array of type Currencies to use to dsplay a full or filtererd list of currencies.
    private var filteredLanguageList: [Language] = [] {
        didSet {
            // Sort array alphabetically
            filteredLanguageList = filteredLanguageList.sorted { $0.name < $1.name }
            filteredLanguageList.insert(autoLanguage, at: 0)
            DispatchQueue.main.async {
                self.languagesListView.tableView.reloadData()
            }
        }
    }
    private let autoLanguage = Language(language: "", name: "Auto")
    
    // MARK: - Life Cycle
    override func loadView() {
        view = languagesListView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissGesture()
        setDelegates()
        setTableViewRefresherControl()
        getLanguages()
    }

    // MARK: - Setup
    private func setDelegates() {
        languagesListView.tableView.delegate = self
        languagesListView.tableView.dataSource = self
        languagesListView.searchBar.delegate = self
    }

    private func setTableViewRefresherControl() {
        languagesListView.tableView.refreshControl = languagesListView.refresherControl
        languagesListView.refresherControl.addTarget(self,
                                            action: #selector(reloadLanguageList),
                                            for: .valueChanged)
    }
    // MARK: - Data resquest
    /// Get all available currencies from API and receive a result  type.
    /// success case:  dictionnary of all currencies available.
    /// failure case : an error.
    private func getLanguages() {
        toggleActiviyIndicator(for: languagesListView.headerView.activityIndicator, shown: true)
        LanguagesService.shared.getData { [weak self] result in
            guard let self = self else {return}
            self.toggleActiviyIndicator(for: self.languagesListView.headerView.activityIndicator, shown: false)
            self.languagesListView.refresherControl.perform(#selector(UIRefreshControl.endRefreshing),
                                                   with: nil,
                                                   afterDelay: 0.1)
            // switch between the result 2 cases
            switch result {
            // if successful iterate thru a currency dictionnary and add each items
            // to the currrencyList array.
            case .success(let languages):
                self.languageList = languages.data.languages
            // if call failed an error is presented to the user.
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }

    /// Reload the entire currency list.
    @objc private func reloadLanguageList() {
        languageList.removeAll()
        languagesListView.searchBar.text = nil
        languagesListView.searchBar.resignFirstResponder()
        getLanguages()
    }
}

// MARK: - Extensions
extension LanguagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLanguageList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        // Set the currency list data to the title and subtitle label.
        let language = filteredLanguageList[indexPath.row]
        cell.textLabel?.text = language.name
        return cell
    }
}

extension LanguagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = filteredLanguageList[indexPath.row]
        // pass the selected row currency object to the ExchangeViewController
        // thru a protocol and dismiss the current modal ViewController.
        let chosenLanguage = Language(language: selectedLanguage.language,
                                               name: selectedLanguage.name)
        languagesDelegate?.updateLanguage(with: chosenLanguage)
        dismiss(animated: true, completion: nil)
    }
}

extension LanguagesListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            filteredLanguageList = languageList.filter({ $0.name.contains(searchText) })
        } else {
            filteredLanguageList = languageList
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        languagesListView.searchBar.resignFirstResponder()
    }
}

