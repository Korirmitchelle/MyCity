//
//  MyCityViewController.swift
//  MyCityViewController
//
//  Created by Mitchelle Korir on 10/12/2021.
//

import UIKit
import GoogleMaps
import GooglePlaces


class MyCityViewController: UIViewController {
    let viewModel = CityViewModel()
    
    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupView()
        fetchCities()
        setupSearchBar()
        setupSegmentedView()
        showListView()
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
    
    func setupMapView(){
        mapView.mapStyle(withFilename: "mapstyle", andType: "json")
    }
    
    func createCityMarkers() {
        self.mapView.clear()
        var markerList = [GMSMarker]()
        for city in self.viewModel.cities {
            if let latitude = city.latitude, let longitude = city.longitude  {
                let marker = GMSMarker()
                marker.map = self.mapView
                marker.iconView = UIImageView(image: R.image.marker())
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                marker.position =  location
                markerList.append(marker)
            }
        }
        MapViewUtils().delay(seconds: 2) { () -> () in
            //fit map to markers
            var bounds = GMSCoordinateBounds()
            for marker in markerList {
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            self.mapView.animate(with: update)
        }
    }
    
    func setupSegmentedView(){
        segmentedView.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    func showMapView(){
        mapView.isHidden = false
        listView.isHidden = true
    }
    
    func showListView(){
        mapView.isHidden = true
        listView.isHidden = false
    }
    
    @objc func segmentedControlChanged() {
        let viewSelected = ViewedSegment(rawValue: segmentedView.selectedSegmentIndex)
        viewSelected == .mapView ? showMapView() : showListView()
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
            self.createCityMarkers()
            self.tableView.reloadData()
        }
    }
}

extension MyCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.fitlerData(word: searchText,completed: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

