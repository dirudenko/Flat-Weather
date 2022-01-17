//
//  MyAppTests.swift
//  MyAppTests
//
//  Created by Dmitry on 15.12.2021.
//

import XCTest
@testable import MyApp

class MyAppTests: XCTestCase {
  
  var networkManager: NetworkManagerProtocol!
  let mockCityList = CitiList(id: 1, name: "Mock", state: "Mock", country: "Mock", coord: Coord(lon: 1, lat: 1))
  
  override func setUpWithError() throws {
    networkManager = NetworkManager()
  }
  
  override func tearDownWithError() throws {
    networkManager = nil
  }
  
  func testCityMoscow() throws {
    let expectation = expectation(description: "Expectation in " + #function)
    var validateResult: WeatherModel?
    networkManager.getWeather(lon: 37.606667, lat: 55.761665) { result in
      switch result {
      case .success(let city):
        validateResult = city
        break
      case .failure(_): XCTFail()
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10) { error in
      if error != nil {
        XCTFail()
      }
      XCTAssert(validateResult != nil)
    }
  }
  
 
  func testCityError() throws {
    let expectation = expectation(description: "Expectation in " + #function)
    networkManager.getWeather(lon: 800, lat: 800) { result in
      switch result {
      case .success(_):
        XCTFail()
      case .failure(_):
        break
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10) { error in
      if error != nil {
        XCTFail()
      }
    }
  }
  
  //    func testPerformanceExample() throws {
  //        // This is an example of a performance test case.
  //        self.measure {
  //            // Put the code you want to measure the time of here.
  //        }
  //    }
  
}
