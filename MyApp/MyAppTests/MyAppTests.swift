//
//  MyAppTests.swift
//  MyAppTests
//
//  Created by Dmitry on 15.12.2021.
//

import XCTest
@testable import MyApp

class MyAppTests: XCTestCase {
  
  var networkManager: NetworkManager!
  var headerWeatherViewController: HeaderWeaherViewController!
  
  override func setUpWithError() throws {
    networkManager = NetworkManager()
    headerWeatherViewController = HeaderWeaherViewController(cityId: 0)
  }
  
  override func tearDownWithError() throws {
    networkManager = nil
  }
  
  func testCityMoscow() throws {
    let expectation = expectation(description: "Expectation in " + #function)
    var validateResult: CurrentWeather?
    let expectedResult = 524901
    
    networkManager.getWeather(city: 524901) { result in
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
      XCTAssertEqual(validateResult?.id, expectedResult)
    }
  }
  
 
//  func testCityError() throws {
//    let expectation = expectation(description: "Expectation in " + #function)
//    
//    networkManager.getWeaher(city: "MockCity") { result in
//      switch result {
//      case .success(_):
//        break
//      case .failure(_): break
//      }
//      expectation.fulfill()
//    }
//    waitForExpectations(timeout: 10) { error in
//      if error != nil {
//        XCTFail()
//      }
//    }
//  }
  
  //    func testPerformanceExample() throws {
  //        // This is an example of a performance test case.
  //        self.measure {
  //            // Put the code you want to measure the time of here.
  //        }
  //    }
  
}
