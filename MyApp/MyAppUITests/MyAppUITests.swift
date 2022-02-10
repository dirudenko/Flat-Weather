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
//    addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
//      print(alert.buttons)
//                alert.buttons["Allow Once"].tap()
//     // alert.buttons[0].ta
//                return true
//            }
    //  app.tap()
  }
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    
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
    //sleep(3)
   // app.swipeDown()
    
   // sleep(3)
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

