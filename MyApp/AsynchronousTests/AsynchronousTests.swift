//
//  AsynchronousTests.swift
//  AsynchronousTests
//
//  Created by Dmitry on 06.02.2022.
//

import XCTest
@testable import MyApp

class AsynchronousTests: XCTestCase {

  var sut: NetworkManagerProtocol!

    override func setUpWithError() throws {
        sut = MockNetworkManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSearchCity() throws {
      let expectation = expectation(description: "Expectation in " + #function)
      let input = "MockCity"
      var output: String?

      sut.getCityName(name: input) { result in
        switch result {
        case .success(let model):

          output = model.first?.name
        case .failure(let error):
          output = error.localizedDescription
        }
        expectation.fulfill()
      }

      waitForExpectations(timeout: 3) { error in
            if error != nil {
              XCTFail()
            }
        XCTAssertEqual(output, input)
          }
    }

  func testSearchCityWithError() throws {
    let expectation = expectation(description: "Expectation in " + #function)
    let input = "StabCity"
    var output: String?

    sut.getCityName(name: input) { result in
      switch result {
      case .success(let model):
      output = model.first?.name
      case .failure(let error):
        output = error.localizedDescription
      }
      expectation.fulfill()
    }

    waitForExpectations(timeout: 3) { error in
          if error != nil {
            XCTFail()
          }
      XCTAssertNotEqual(output, input)
        }
  }

  func testSearchWeather() throws {
    let expectation = expectation(description: "Expectation in " + #function)
    let inputLat: Double = MockWeatherModel.city.lat
    let inputLon: Double = MockWeatherModel.city.lon
    var output: WeatherModel?

    sut.getWeather(lon: inputLon, lat: inputLat) { result in
      switch result {
      case .success(let model):

        output = model
      case .failure(_):
        output = nil
      }
      expectation.fulfill()
    }

    waitForExpectations(timeout: 3) { error in
          if error != nil {
            XCTFail()
          }
     XCTAssertNotNil(output)
        }
  }

  func testSearchWeatherWithError() throws {
    let expectation = expectation(description: "Expectation in " + #function)
    let inputLat: Double = 123
    let inputLon: Double = 456
    var output: WeatherModel?

    sut.getWeather(lon: inputLon, lat: inputLat) { result in
      switch result {
      case .success(let model):

        output = model
      case .failure(_):
        output = nil
      }
      expectation.fulfill()
    }

    waitForExpectations(timeout: 3) { error in
          if error != nil {
            XCTFail()
          }
     XCTAssertNil(output)
        }
  }
}
