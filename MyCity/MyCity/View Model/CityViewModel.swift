//
//  CityViewModel.swift
//  MyCity
//
//  Created by Mitchelle Korir on 10/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

protocol ViewModelToViewDelegate {
    func dataReceived()
}

class CityViewModel  {
    var pageLimit = 15
    private var currentPage: Int = 1
    var delegate: ViewModelToViewDelegate?
    let disposeBag = DisposeBag()

    
    var cities = [City]() {
        didSet {
            self.delegate?.dataReceived()
        }
    }
    
    func fetchData(completed: ((Bool) -> Void)? = nil) {
        self.observeRealm()
        APIManager.shared.getCities(filter: "", page: currentPage).subscribe(onNext:  {[weak self] response in
            self?.pageLimit = response.data.pagination.perPage ?? 15
            self?.addToRealm(cities: response.data.items)

            if let page = response.data.pagination.currentPage {
                self?.currentPage = page + 1
            }
            completed?(true)
        }, onError: { error in
            completed?(false)
        }).disposed(by: disposeBag)
        
    }
    
    func fitlerData(word:String,completed: ((Bool) -> Void)? = nil) {
        cities.removeAll()
        APIManager.shared.getCities(filter: word, page: 1).subscribe(onNext:  {[weak self] response in
            self?.cities.append(contentsOf: response.data.items)
            self?.pageLimit = response.data.pagination.perPage ?? 15
            completed?(true)
        }, onError: { error in
            completed?(false)
        }).disposed(by: disposeBag)
    }
    
    private func addToRealm(cities: [City]) {
        DispatchQueue.main.async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(cities, update: .modified)
            }
        }
    }
    
    func observeRealm() {
        let realm = try! Realm()
        let cities = realm.objects(City.self)
        Observable.collection(from: cities)
          .map { cities in
              self.cities = cities.toArray()
          }
          .subscribe(onNext: { text  in
            print("heeee \(text)")
          })
    }
}
