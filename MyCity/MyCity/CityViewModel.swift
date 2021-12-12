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
        APIManager.shared.getUsers(perPage: pageLimit, sinceId: currentPage) { [weak self] result in
            switch result {
            case .success(let users):
                self?.cities.append(contentsOf: users.data.items)
                self?.pageLimit = users.data.pagination.perPage ?? 15
                if let page = users.data.pagination.currentPage {
                    self?.currentPage = page + 1
                }
                print("current \(self?.currentPage)")
                completed?(true)
            case .failure(let error):
                print(error.localizedDescription)
                completed?(false)
            }
        }
    }
}
