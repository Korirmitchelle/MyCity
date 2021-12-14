//
//  Endpoints.swift
//  MyCity
//
//  Created by Mitchelle Korir on 14/12/2021.
//

import Foundation

struct EndPoint {
    
    static let citiesUrl: URLComponents = {
        var components = URLComponents(
            url: URL(string: "http://connect-demo.mobile1.io/square1/connect/v1/city")!,
            resolvingAgainstBaseURL: false
        )
        return components ?? URLComponents()
    }()
}
