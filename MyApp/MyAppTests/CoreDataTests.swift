//
//  CoreDataTests.swift
//  MyAppTests
//
//  Created by Dmitry on 18.12.2021.
//

import XCTest
@testable import MyApp

class CoreDataTests: XCTestCase {
  
  var coreDataManager: TestCoreDataManager!
  let mockCity = CitiList(id: 1, name: "Mock", state: "Mock", country: "Mock", coord: MockData.coord)

    override func setUpWithError() throws {
        coreDataManager = TestCoreDataManager(modelName: "MyApp")
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
    }

    func testExample() throws {
      coreDataManager.configure(json: mockCity)
      coreDataManager.saveContext()
      coreDataManager.loadSavedData()
      print(coreDataManager.testFetchedResultsController.object(at: [0,0]).name)
      XCTAssertTrue(coreDataManager.testFetchedResultsController.object(at: [0,0]).name == "Mock")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
