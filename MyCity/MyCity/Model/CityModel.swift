//
//  CityModel.swift
//  MyCity
//
//  Created by Mitchelle Korir on 12/12/2021.
//

import Foundation
import RealmSwift

class OptionalFloat: Object, Decodable {
    private var numeric = RealmOptional<Float>()
    
    required override init() {
        super.init()
    }
    
    init(numeric: Float) {
        super.init()
        self.numeric = RealmOptional<Float>(numeric)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self.init()
        
        let singleValueContainer = try decoder.singleValueContainer()
        if singleValueContainer.decodeNil() == false {
            let value = try singleValueContainer.decode(Float.self)
            numeric = RealmOptional(value)
        }
    }
    
    var value: Float? {
        return numeric.value
    }
    
    var zeroOrValue: Float {
        return numeric.value ?? 0
    }
}

struct CityModel:Decodable{
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

struct Data:Decodable {
    let items: [City]
    let pagination : Pagination
    
    enum CodingKeys:String, CodingKey {
        case items
        case pagination
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([City].self, forKey: .items)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }
}

class City: Object, Decodable {
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String?
    @objc dynamic var localName:String?
    @objc dynamic var latitude:OptionalFloat?
    @objc dynamic var longitude:OptionalFloat?
    @objc dynamic var createdDate:String?
    @objc dynamic var updatedDate:String?
    @objc dynamic var countryId:Int = 0
    
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
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    public required convenience  init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        localName = try? container.decode(String.self, forKey: .localName)
        latitude = try? container.decode(OptionalFloat.self, forKey: .latitude)
        longitude = try? container.decode(OptionalFloat.self, forKey: .longitude)
        createdDate = try? container.decode(String.self, forKey: .createdDate)
        updatedDate = try? container.decode(String.self, forKey: .updatedDate)
        countryId = try container.decode(Int.self, forKey: .countryId)
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
