//
//  CityViewModelTests.swift
//  MyCityTests
//
//  Created by Mitchelle Korir on 15/12/2021.
//

import XCTest
import RxSwift

@testable import MyCity



class CityViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    private func initCity(id: Int) -> City {
        let city = City()
        city.id = 54
        city.name = "Malindi"
        city.latitude = OptionalFloat(numeric: 1.37377373)
        city.longitude = OptionalFloat(numeric: 36.37377373)
        city.countryId = 10
        city.createdDate = Date().ISO8601Format()
        city.localName = "Coast"
        city.updatedDate = Date().ISO8601Format()
        return city
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testCities() throws {
        var expectedCityResult = [City]()
        expectedCityResult.append(self.initCity(id: 1))
        expectedCityResult.append(self.initCity(id: 2))
       
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
