//
//  SettingsViewModelTests.swift
//  MyAppTests
//
//  Created by Dmitry on 08.02.2022.
//

import XCTest
@testable import MyApp

class SettingsViewModelTests: XCTestCase {

  var sut: SettingsViewModelProtocol!
  var observer: SettingsObserver!

    override func setUpWithError() throws {
      observer = SettingsObserver()
      sut  = SettingsViewModel(observer: observer)

    }

    override func tearDownWithError() throws {
       observer = nil
      sut = nil
    }

    func testChangeTemperature() throws {
      let inputUnit: Temperature = .celcius

      sut.changeSettings(unit: inputUnit, type: .temperature)

      let outputUnit: Temperature = UserDefaultsManager.get(forKey: "Temperature")!

      XCTAssertEqual(inputUnit, outputUnit)
    }

  func testChangeWind() throws {
    let inputUnit: WindSpeed = .kmh

    sut.changeSettings(unit: inputUnit, type: .wind)

    let outputUnit: WindSpeed = UserDefaultsManager.get(forKey: "Wind")!

    XCTAssertEqual(inputUnit, outputUnit)
  }

  func testChangePressure() throws {
    let inputUnit: Pressure = .mmHg

    sut.changeSettings(unit: inputUnit, type: .pressure)

    let outputUnit: Pressure = UserDefaultsManager.get(forKey: "Pressure")!

    XCTAssertEqual(inputUnit, outputUnit)
  }

  func testObserverRegister() throws {
    XCTAssertTrue(!observer.observers.isEmpty)
  }

  func testObserverDeregister() throws {
    observer.deregister()
    XCTAssertTrue(observer.observers.isEmpty)
  }

}
