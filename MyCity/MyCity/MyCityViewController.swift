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
        title = "Cities of the word"
        tableView.rowHeight = 64
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
    }
    
    func fetchCities(){
        viewModel.fetchData{ [weak self] success in
            if !success {
                //                self?.hideBottomLoader()
            }
        }
    }
    
    func setupSearchBar(){
        searchBar.delegate = self
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
            let repo = viewModel.cities[indexPath.row]
            cell.textLabel?.text = repo.name
            cell.textLabel?.textColor = .label
            cell.detailTextLabel?.text = "\(repo.id)"
        case .loader:
            cell.textLabel?.text = "Loading.."
            cell.textLabel?.textColor = .systemBlue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !viewModel.cities.isEmpty else { return }
        
        if section == .loader {
            print("load new data..")
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
        print("test here \(searchText)")
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
