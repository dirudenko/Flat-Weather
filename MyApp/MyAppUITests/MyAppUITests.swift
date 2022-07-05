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
    if #available(iOS 13.4, *) {
      app.resetAuthorizationStatus(for: .location)
    } else {
      throw XCTSkip("Required API is not available for this test.")
    }
  }
  
  func testAddFirstCityMoscow() throws {
    
    if app.isOnMainView {
      app.buttons["pushSearch"].tap()
    }
    let searchField = app.otherElements["Search"].searchFields.firstMatch
    tapElementAndWaitForKeyboardToAppear(element: searchField)
    searchField.typeText("Moscow")
    sleep(1)
    app.tables.cells.element(boundBy: 0).tap()
    XCTAssertTrue(app.isOnMainView)
    snapshot("1 - MoscowFullScreen")
    XCTAssertTrue(app.staticTexts["topTemperature"].exists)
    app.swipeUp()
    snapshot("2 - MoscowSmallScreen")
    app.swipeDown()
  }
  
  func testAddThirdCityMale() throws {
    
    if app.isOnMainView {
      app.buttons["pushSearch"].tap()
    }
    let searchField = app.otherElements["Search"].searchFields.firstMatch
    var element: XCUIElement
    tapElementAndWaitForKeyboardToAppear(element: searchField)
    repeat {
      searchField.typeText("Male")
      element = app.tables.cells.element(boundBy: 0)
      sleep(1)
      searchField.typeText("")
    } while !element.exists
    element.tap()
    XCTAssertTrue(app.isOnMainView)
    snapshot("3 - MaleFullScreen")
    XCTAssertTrue(app.staticTexts["topTemperature"].exists)
    app.swipeUp()
    snapshot("4 - MaleSmallScreen")
    app.swipeDown()
  }
  
  func testAddSecondCityKazan() throws {
    if app.isOnMainView {
      app.buttons["pushSearch"].tap()
    }
    var element: XCUIElement
    let searchField = app.otherElements["Search"].searchFields.firstMatch
    tapElementAndWaitForKeyboardToAppear(element: searchField)
    searchField.tap()
    repeat {
      searchField.typeText("Kazan")
      element = app.tables.cells.element(boundBy: 0)
      sleep(1)
      searchField.typeText("")
    } while !element.exists
    
    element.tap()
    XCTAssertTrue(app.isOnMainView)
    snapshot("5 - KazanFullScreen")
    XCTAssertTrue(app.staticTexts["topTemperature"].exists)
    app.swipeUp()
    snapshot("6 - KazanSmallScreen")
    app.swipeRight()
    app.buttons["pushSearch"].tap()
    snapshot("7 - search")
  }
  
  func testSettings() throws {
    app.buttons["pustSettings"].tap()
    snapshot("7 - settings")
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

extension XCTestCase {
  
  func tapElementAndWaitForKeyboardToAppear(element: XCUIElement) {
    let keyboard = XCUIApplication().keyboards.element
    while (true) {
      element.tap()
      if keyboard.exists {
        break
      }
      RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 0.5) as Date)
    }
  }
}
