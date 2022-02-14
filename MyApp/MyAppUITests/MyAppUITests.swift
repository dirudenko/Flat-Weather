//
//  MyAppUITests.swift
//  MyAppUITests
//
//  Created by Dmitry on 15.12.2021.
//

import XCTest

class MyAppUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    app = XCUIApplication()
    continueAfterFailure = false
    app.launchArguments.append("--UITesting")
    setupSnapshot(app)
    app.launch()
  }
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testAddFirstCityMoscow() throws {
    
    if app.isOnMainView {
      app.buttons["pushSearch"].tap()
    }
    // XCTAssertTrue(app.isOnSearchView)
    snapshot("1 - search")
    
    let searchField = app.otherElements["Search"].searchFields.firstMatch
    
    searchField.tap()
    searchField.typeText("Moscow")
    sleep(1)
    app.tables.staticTexts["Moscow RU"].tap()
    
    XCTAssertTrue(app.isOnMainView)
    app.staticTexts["topTemperature"].waitForExistence(timeout: 5)
    snapshot("2 - fullScreen")
    XCTAssertTrue(app.staticTexts["topTemperature"].exists)
    app.swipeUp()
    snapshot("3 - smallScreen")
    sleep(1)
    app.swipeDown()
    
    // sleep(3)
  }
    
  func testAddSecondCityLondon() throws {
    if app.isOnMainView {
      app.buttons["pushSearch"].tap()
    }
    // XCTAssertTrue(app.isOnSearchView)
    snapshot("4 - search")
    
    let searchField = app.otherElements["Search"].searchFields.firstMatch
    
    searchField.tap()
    searchField.typeText("London")
    sleep(1)
    app.tables.staticTexts["London GB"].tap()
    
    XCTAssertTrue(app.isOnMainView)
    app.staticTexts["topTemperature"].waitForExistence(timeout: 5)
    snapshot("5 - fullScreen")
    XCTAssertTrue(app.staticTexts["topTemperature"].exists)
    app.swipeUp()
    snapshot("6 - smallScreen")
    sleep(1)
    app.swipeRight()
    app.buttons["pushSearch"].tap()
    snapshot("7 - search")
    sleep(1)
  }
  
  func testSettings() throws {
      app.buttons["pustSettings"].tap()
    // XCTAssertTrue(app.isOnSearchView)
    
    snapshot("7 - settings")
    sleep(1)
  }
}

extension XCUIApplication {
  var isOnMainView: Bool {
    return otherElements["mainWeather"].exists
  }
  
  var isOnSearchView: Bool {
    return otherElements["searchView"].exists
  }
}

