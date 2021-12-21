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

    func testAddMockCity() throws {
      coreDataManager.configure(json: mockCity)
      coreDataManager.saveContext()
      coreDataManager.loadSavedData()
      XCTAssertNotNil(coreDataManager.fetchedResultsController.fetchedObjects?.first?.lat)
      XCTAssertTrue(coreDataManager.fetchedResultsController.fetchedObjects?.first?.name == "Mock")
    }
  
  func testPredicate() throws {
    coreDataManager.configure(json: mockCity)
    coreDataManager.saveContext()
    coreDataManager.cityListPredicate = NSPredicate(format: "name CONTAINS %@", "M")
    coreDataManager.loadSavedData()
    XCTAssertTrue(coreDataManager.fetchedResultsController.fetchedObjects?.first?.name == "Mock")
  }
  
  func testPredicateWithFail() throws {
    coreDataManager.configure(json: mockCity)
    coreDataManager.saveContext()
    coreDataManager.cityListPredicate = NSPredicate(format: "name CONTAINS %@", "s")
    coreDataManager.loadSavedData()
    XCTAssertNil(coreDataManager.fetchedResultsController.fetchedObjects?.first?.name)
  }

//    func testPerformanceFetchFromJSON() throws {
//      let decoder = JSONDecoder()
//      guard let fileURL = Bundle.main.url(forResource:"city.list", withExtension: "json"),
//            let fileContents = try? String(contentsOf: fileURL) else { return }
//      let data = Data(fileContents.utf8)
//
//        let list = try decoder.decode([CitiList].self, from: data)
//        self.measure {
//          for item in list {
//            self.coreDataManager.configure(json: item)
//          }
//          coreDataManager.saveContext()
//          coreDataManager.loadSavedData()
//        }
//    }

}
