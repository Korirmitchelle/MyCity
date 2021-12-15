//
//  APIManager.swift
//  MyCity
//
//  Created by Mitchelle Korir on 12/12/2021.
//

import Foundation
import RxSwift
import RealmSwift
import SwiftUI
import RxCocoa

enum APIError: Error {
    case invalidUrl
    case errorDecode
    case failed(error: Error)
    case unknownError
}


struct APIManager {
    static let shared = APIManager()
    
    func getCities(filter: String, page: Int) -> Observable<CityModel> {
        return Observable.create{observer -> Disposable in
            var components = EndPoint.citiesUrl
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "filter[0][name][contains]", value: "\(filter)")
            ]
            guard let url = components.url else {
                observer.onError(APIError.invalidUrl)
                return Disposables.create {}
            }
            let urlRequest = URLRequest(url: url, timeoutInterval: 10)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error  in
                if error != nil {
                    observer.onError(APIError.failed(error: error!))
                } else if let data = data {
                    do {
                        let cityModel = try JSONDecoder().decode(CityModel.self, from: data)
                        observer.onNext(cityModel)
                    } catch {
                        observer.onError(APIError.errorDecode)
                    }
                } else {
                    observer.onError(APIError.unknownError)
                }
            }
            .resume()
            return Disposables.create {}
        }
    }
}
