//
//  CityViewModel.swift
//  MyCity
//
//  Created by Mitchelle Korir on 10/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelToViewDelegate {
    func dataReceived()
}

class CityViewModel  {
    var pageLimit = 15
    private var currentPage: Int = 1
    var delegate: ViewModelToViewDelegate?
    
    var cities = [Items]() {
        didSet {
            self.delegate?.dataReceived()
        }
    }
    
    func fetchData(completed: ((Bool) -> Void)? = nil) {
        APIManager.shared.getCities(filter: "", page: currentPage) { [weak self] result in
            switch result {
            case .success(let users):
                self?.cities.append(contentsOf: users.data.items)
                self?.pageLimit = users.data.pagination.perPage ?? 15
                if let page = users.data.pagination.currentPage {
                    self?.currentPage = page + 1
                }
                completed?(true)
            case .failure(let error):
                completed?(false)
            }
        }
    }
    
    func fitlerData(word:String,completed: ((Bool) -> Void)? = nil) {
        cities.removeAll()
        APIManager.shared.getCities(filter: word, page: 1) { [weak self] result in
            switch result {
            case .success(let users):
                self?.cities.append(contentsOf: users.data.items)
                self?.pageLimit = users.data.pagination.perPage ?? 15
                completed?(true)
            case .failure(let error):
                completed?(false)
            }
        }
    }
}
