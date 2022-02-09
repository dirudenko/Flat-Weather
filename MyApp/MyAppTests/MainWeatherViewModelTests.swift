//
//  MainWeatherViewModelTests.swift
//  MyAppTests
//
//  Created by Dmitry on 08.02.2022.
//

import XCTest
@testable import MyApp


class MainWeatherViewModelTests: XCTestCase {
  
  var sut: MainWeatherViewModelProtocol!
  let coreDataManager = TestCoreDataManager(modelName: "MyApp")
  let networkManager = MockNetworkManager()
  var observer: SettingsObserver!
  let mockWeatherModel = MockWeatherModel.city
  var mockCity = SearchModel(name: "MockCity", localNames: nil, lat: 37.39, lon: -122.08, country: "MockCountry", state: nil)
  
  func configureCoreData() {
    coreDataManager.saveToList(city: mockCity, isCurrentLocation: false)
    coreDataManager.loadSavedData()
  }
  
  override func setUpWithError() throws {
    observer = SettingsObserver()
    configureCoreData()
    let city = coreDataManager.fetchedResultsController.fetchedObjects?.first
    sut = MainWeatherViewModel(for: city!, networkManager: networkManager, coreDataManager: coreDataManager, observer: observer)
  }
  
  override func tearDownWithError() throws {
    observer = nil
    sut = nil
  }
  
  func testCheckDateOutdated() throws {
    let output = sut.checkDate()
    XCTAssertTrue(output)
  }
  
  func testLoadData() throws {
    sut.loadWeather()
    let output = coreDataManager.fetchedResultsController.fetchedObjects?.first?.unitTypes
    XCTAssertTrue(output != nil)
  }
}
