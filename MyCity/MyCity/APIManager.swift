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

    func getUsers(perPage: Int = 30, sinceId: Int, completion: @escaping (Result<CityModel, APIError>) -> Void) {
        var components = URLComponents(string: "http://connect-demo.mobile1.io/square1/connect/v1/city")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(sinceId)"),
        ]
        guard let url = components.url else {
            completion(.failure(.invalidUrl))
            return
        }
        let urlRequest = URLRequest(url: url, timeoutInterval: 10)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error  in
            if error != nil {
                print("dataTask error: \(error!.localizedDescription)")
                completion(.failure(.failed(error: error!)))
            } else if let data = data {
                do {
                    let users = try JSONDecoder().decode(CityModel.self, from: data)
                    print("success")
                    completion(.success(users))
                } catch {
                    print("decoding error")
                    completion(.failure(.errorDecode))
                }
            } else {
                print("unknown dataTask error")
                completion(.failure(.unknownError))
            }
        }
        .resume()
    }
}
