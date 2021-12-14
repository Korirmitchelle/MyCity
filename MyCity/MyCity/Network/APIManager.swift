//
//  APIManager.swift
//  MyCity
//
//  Created by Mitchelle Korir on 12/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidUrl
    case errorDecode
    case failed(error: Error)
    case unknownError
}


struct APIManager {
    static let shared = APIManager()

    func getCities(filter: String, page: Int, completion: @escaping (Result<CityModel, APIError>) -> Void) {
        var components = EndPoint.citiesUrl
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "filter[0][name][contains]", value: "\(filter)")
        ]
        guard let url = components.url else {
            completion(.failure(.invalidUrl))
            return
        }
        let urlRequest = URLRequest(url: url, timeoutInterval: 10)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error  in
            if error != nil {
                completion(.failure(.failed(error: error!)))
            } else if let data = data {
                do {
                    let users = try JSONDecoder().decode(CityModel.self, from: data)
                    completion(.success(users))
                } catch {
                    completion(.failure(.errorDecode))
                }
            } else {
                completion(.failure(.unknownError))
            }
        }
        .resume()
    }
}
