//
//  SearchViewModelTests.swift
//  MyAppTests
//
//  Created by Dmitry on 06.02.2022.
//

import XCTest
@testable import MyApp

class SearchViewModelTests: XCTestCase {

  var sut: SearchViewCellModelProtocol!
  let coreDataManager = TestCoreDataManager(modelName: "MyApp")
  let networkManager = MockNetworkManager()
  let mockCity = SearchModel(name: "MockCity", localNames: nil, lat: 123, lon: 456, country: "MockCountry", state: nil)
  let mockWeatherModel = MockWeatherModel.city

  func configureCoreData() {
    coreDataManager.saveToList(city: mockCity, isCurrentLocation: false)
    coreDataManager.loadSavedData()
  }

  override func setUpWithError() throws {
    sut = SearchViewCellModel(networkManager: networkManager, coreDataManager: coreDataManager)

  }

  override func tearDownWithError() throws {
    sut = nil

  }

  func testSectionsForCityListTableViewCell() throws {
    configureCoreData()
    let input: TableViewCellTypes = .cityListTableViewCell
    let output = 1

    let result = sut.setSections(at: input)
    XCTAssertEqual(result, output)
  }

  func testSectionsForStandartTableViewCell() throws {
    let input: TableViewCellTypes = .standartTableViewCell
    let output = 1

    let result = sut.setSections(at: input)
    XCTAssertEqual(result, output)
  }

  func testGetObjects() throws {
    configureCoreData()
    let output = coreDataManager.fetchedResultsController.fetchedObjects?.first

    let result = sut.getObjects(at: 0)
    XCTAssertEqual(result, output)
  }
}
