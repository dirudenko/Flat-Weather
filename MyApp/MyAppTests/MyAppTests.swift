//
//  MyAppTests.swift
//  MyAppTests
//
//  Created by Dmitry on 15.12.2021.
//

import XCTest
@testable import MyApp

class MyAppTests: XCTestCase {
 
//  /// System under test 
//  var sut: NetworkManagerProtocol!
//  
//  
//  override func setUpWithError() throws {
//    try super.setUpWithError()
//    sut = NetworkManager()
//  }
//  
//  override func tearDownWithError() throws {
//    sut = nil
//    try super.tearDownWithError()
//  }
//  
//  func testCityMoscow() throws {
//    let expectation = expectation(description: "Expectation in " + #function)
//    var validateResult: WeatherModel?
//    sut.getWeather(lon: 37.606667, lat: 55.761665) { result in
//      switch result {
//      case .success(let city):
//        validateResult = city
//        break
//      case .failure(_): XCTFail()
//      }
//      expectation.fulfill()
//    }
//    waitForExpectations(timeout: 10) { error in
//      if error != nil {
//        XCTFail()
//      }
//      XCTAssert(validateResult != nil)
//    }
//  }
//  
// 
//  func testCityError() throws {
//    let expectation = expectation(description: "Expectation in " + #function)
//    sut.getWeather(lon: 800, lat: 800) { result in
//      switch result {
//      case .success(_):
//        XCTFail()
//      case .failure(_):
//        break
//      }
//      expectation.fulfill()
//    }
//    waitForExpectations(timeout: 10) { error in
//      if error != nil {
//        XCTFail()
//      }
//    }
//  }
//  
//      func testPerformanceExample() throws {
//          self.measure {
//            let someArray = Array(0...10000)
//            var counter = 0
//            
//            someArray.forEach {
//              counter += $0
//            }
//          }
//      }
  
}
