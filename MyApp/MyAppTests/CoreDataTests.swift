//
//  CoreDataTests.swift
//  MyAppTests
//
//  Created by Dmitry on 18.12.2021.
//

import XCTest
@testable import MyApp

class CoreDataTests: XCTestCase {
  
  var sut: CoreDataManagerResultProtocol!
  let mockCity = SearchModel(name: "MockCity", localNames: nil, lat: 123, lon: 456, country: "MockCountry", state: nil)
  let mockWeatherModel = MockWeatherModel.city
  
  func configureCoreData() {
    sut.saveToList(city: mockCity, isCurrentLocation: false)
    sut.loadSavedData()
  }
  
  override func setUpWithError() throws {
    sut = TestCoreDataManager(modelName: "MyApp")
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testAddMockCity() throws {
    configureCoreData()
    XCTAssertNotNil(sut.fetchedResultsController.fetchedObjects?.first?.lat)
    XCTAssertTrue(sut.fetchedResultsController.fetchedObjects?.first?.name == "MockCity")
  }
  
  func testPredicate() throws {
    configureCoreData()
    sut.cityResultsPredicate = NSPredicate(format: "name CONTAINS %@", "M")
    sut.loadSavedData()
    XCTAssertTrue(sut.fetchedResultsController.fetchedObjects?.first?.name == "MockCity")
  }
  
  func testPredicateWithFail() throws {
    configureCoreData()
    sut.cityResultsPredicate = NSPredicate(format: "name CONTAINS %@", "X")
    sut.loadSavedData()
    XCTAssertNil(sut.fetchedResultsController.fetchedObjects?.first?.name)
  }
  
  
  func testTopBarIsNotNil() {
    configureCoreData()
    let list = sut.fetchedResultsController.fetchedObjects?.first
    sut.configureTopView(from: mockWeatherModel, list: list)
    XCTAssertNotNil(sut.fetchedResultsController.fetchedObjects?.first?.topWeather)
  }
  
  func testBottomBarIsNotNil() {
    configureCoreData()
    let list = sut.fetchedResultsController.fetchedObjects?.first
    sut.configureBottomView(from: mockWeatherModel, list: list)
    XCTAssertNotNil(sut.fetchedResultsController.fetchedObjects?.first?.bottomWeather)
  }
  
  func testHourlyBarIsNotNil() {
    configureCoreData()
    let list = sut.fetchedResultsController.fetchedObjects?.first
    sut.configureHourly(from: mockWeatherModel, list: list)
    XCTAssertNotNil(sut.fetchedResultsController.fetchedObjects?.first?.hourlyWeather)
  }
  
  func testWeeklyBarIsNotNil() {
    configureCoreData()
    let list = sut.fetchedResultsController.fetchedObjects?.first
    sut.configureWeekly(from: mockWeatherModel, list: list)
    XCTAssertNotNil(sut.fetchedResultsController.fetchedObjects?.first?.weeklyWeather)
  }
  
  func testUnitsTypesIsNotNil() {
    configureCoreData()
    let list = sut.fetchedResultsController.fetchedObjects?.first
    sut.updateUnitTypes(list: list)
    XCTAssertNotNil(sut.fetchedResultsController.fetchedObjects?.first?.unitTypes)
  }
  
  func testIsEntytyIsNotEmpty() {
    configureCoreData()
    XCTAssertFalse(sut.entityIsEmpty())
  }
  
  func testIsEntytyIsEmpty() {
    XCTAssertTrue(sut.entityIsEmpty())
  }
  
  func testRemoveDataFromCOreData() {
    configureCoreData()
    let list = sut.fetchedResultsController.fetchedObjects?.first
    
    sut.configureTopView(from: mockWeatherModel, list: list)
    sut.configureBottomView(from: mockWeatherModel, list: list)
    sut.configureHourly(from: mockWeatherModel, list: list)
    
    sut.removeDataFromMainWeather(object: list!)
    
    XCTAssertTrue(sut.entityIsEmpty())
  }
  
}
