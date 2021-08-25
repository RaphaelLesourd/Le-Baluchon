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

    // MARK: - Properties
    var addAutoLanguageOption = true
    private let autoLanguage = Language(language: "", name: "Auto")

    weak var languagesDelegate: LanguagesListDelegate?
    private let languagesService = LanguagesService()
    private let languagesListView = ListView(title: "Langues")
    private var languageList: [Language] = [] {
        didSet{
            filteredLanguageList = languageList
        }
    }
    private var filteredLanguageList: [Language] = [] {
        didSet {
            filteredLanguageList = filteredLanguageList.sorted { $0.name < $1.name }
            if addAutoLanguageOption {
                filteredLanguageList.insert(autoLanguage, at: 0)
            }
            DispatchQueue.main.async {
                self.languagesListView.tableView.reloadData()
            }
        }
    }
    
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
        languagesListView.refresherControl
            .addTarget(self, action: #selector(reloadLanguageList), for: .valueChanged)
    }

    // MARK: - Data resquest
    /// Get all available currencies from API and receive a result  type.
    /// success case:  dictionnary of all currencies available.
    /// failure case : an error.
    private func getLanguages() {
        displayRefresherActivityControls(true)
        languagesService.getLanguages { [weak self] result in
            guard let self = self else {return}
            self.displayRefresherActivityControls(false)
            switch result {
            case .success(let languages):
                self.languageList = languages.data.languages
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

    /// Show/start or hide/stop activity control
    /// - Parameter status: Bool to set if activity control should be displayed or not
    private func displayRefresherActivityControls(_ status: Bool) {
        self.toggleActiviyIndicator(for: self.languagesListView.headerView.activityIndicator,
                                    and: self.languagesListView.refresherControl,
                                    showing: status)
    }
}

// MARK: - SearchBar Delegate
extension LanguagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLanguageList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let language = filteredLanguageList[indexPath.row]
        cell.textLabel?.text = language.name
        return cell
    }
}

// MARK: - SearchBar Delegate
extension LanguagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = filteredLanguageList[indexPath.row]

        let language = Language(language: selectedLanguage.language,
                                name: selectedLanguage.name)
        languagesDelegate?.updateLanguage(with: language)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SearchBar Delegate
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

