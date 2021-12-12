//
//  CityModel.swift
//  MyCity
//
//  Created by Mitchelle Korir on 12/12/2021.
//

import Foundation

struct CityModel:Codable{
    let time: Int
    let data: Data
    
    enum CodingKeys:String, CodingKey {
        case time
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        data = try container.decode(Data.self, forKey: .data)
    }
    
}

struct Data:Codable {
    let items: [Items]
    let pagination : Pagination
    
    enum CodingKeys:String, CodingKey {
        case items
        case pagination
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([Items].self, forKey: .items)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }
}

struct Items:Codable {
    let id:Int?
    let name:String?
    let localName:String?
    let latitude:Float?
    let longitude:Float?
    let createdDate:String?
    let updatedDate:String?
    let countryId:Int?
    
    enum CodingKeys:String, CodingKey {
        case id
        case name = "name"
        case localName = "local_name"
        case latitude = "lat"
        case longitude = "lng"
        case createdDate = "created_at"
        case updatedDate = "updated_at"
        case countryId = "country_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        localName = try? container.decode(String.self, forKey: .localName)
        latitude = try? container.decode(Float.self, forKey: .latitude)
        longitude = try? container.decode(Float.self, forKey: .longitude)
        createdDate = try? container.decode(String.self, forKey: .createdDate)
        updatedDate = try? container.decode(String.self, forKey: .updatedDate)
        countryId = try? container.decode(Int.self, forKey: .countryId)
    }
    
}

struct Pagination:Codable {
    let currentPage:Int?
    let lastPage:Int?
    let perPage:Int?
    let total:Int?
    
    enum CodingKeys:String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try container.decode(Int.self, forKey: .currentPage)
        lastPage = try container.decode(Int.self, forKey: .lastPage)
        perPage = try container.decode(Int.self, forKey: .perPage)
        total = try container.decode(Int.self, forKey: .total)
    }
    
}


enum TableSection: Int {
    case userList
    case loader
}
