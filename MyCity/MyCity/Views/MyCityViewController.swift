//
//  MyCityViewController.swift
//  MyCityViewController
//
//  Created by Mitchelle Korir on 10/12/2021.
//

import UIKit

class MyCityViewController: UIViewController {
    let viewModel = CityViewModel()
    
    enum TableSection: Int {
        case userList
        case loader
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchCities()
        setupSearchBar()
    }
    
    private func setupView() {
        title = R.string.localizable.navigationTitle()
        tableView.rowHeight = 64
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
    }
    
    func fetchCities(){
        viewModel.fetchData(completed: nil)
    }
    
    func setupSearchBar(){
        searchBar.delegate = self
        searchBar.searchTextField.addKeyboardDoneButton()
    }
}

extension MyCityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .userList:
            return viewModel.cities.count
        case .loader:
            return viewModel.cities.count >= viewModel.pageLimit ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        switch section {
        case .userList:
            let city = viewModel.cities[indexPath.row]
            cell.textLabel?.text = city.name
            cell.textLabel?.textColor = .label
            if let cityId = city.id{
                cell.detailTextLabel?.text = String(cityId)
            }
        case .loader:
            cell.textLabel?.text = R.string.localizable.loadingText()
            cell.textLabel?.textColor = .systemBlue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !viewModel.cities.isEmpty else { return }
        
        if section == .loader {
            self.viewModel.fetchData { [weak self] success in
                if !success {
                    self?.hideBottomLoader()
                }
            }
        }
    }
    
    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.viewModel.cities.count - 1, section: TableSection.userList.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}

extension MyCityViewController:ViewModelToViewDelegate{
    func dataReceived() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MyCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.fitlerData(word: searchText){ _ in
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
