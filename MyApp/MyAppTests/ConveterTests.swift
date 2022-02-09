//
//  ConveterTests.swift
//  MyAppTests
//
//  Created by Dmitry on 05.02.2022.
//

import XCTest
@testable import MyApp

class ConveterTests: XCTestCase {

  var sut: DataConverter!

  override func setUpWithError() throws {
    sut = DataConverter()

  }

  override func tearDownWithError() throws {
    sut = nil
  }
  /// Temperature Converter
  func test0CelciusIs32Fahrenheit() throws {
    let input: Double = 0
    let output: Double = 32

    let result = sut.convertTemperature(value: input, unit: .fahrenheit)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test50FahrenheitIs10Celcius() throws {
    let input: Double = 50
    let output: Double = 10

    let result = sut.convertTemperature(value: input, unit: .celcius)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  /// Wind Speed Converter
  func test10msIs36kmh() throws {

    let input: Double = 10
    let output: Double = 36

    let result = sut.convertWindSpeed(value: input, from: .ms, to: .kmh)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test4msIs9mph() throws {

    let input: Double = 4
    let output: Double = 8.95

    let result = sut.convertWindSpeed(value: input, from: .ms, to: .milh)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test10kmhIs6mph() throws {

    let input: Double = 10
    let output: Double = 6.21

    let result = sut.convertWindSpeed(value: input, from: .kmh, to: .milh)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test36kmhIs10ms() throws {

    let input: Double = 36
    let output: Double = 10

    let result = sut.convertWindSpeed(value: input, from: .kmh, to: .ms)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test10mphIs16kmh() throws {

    let input: Double = 10
    let output: Double = 16.1

    let result = sut.convertWindSpeed(value: input, from: .milh, to: .kmh)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test16mphIs7ms() throws {

    let input: Double = 16
    let output: Double = 7.15

    let result = sut.convertWindSpeed(value: input, from: .milh, to: .ms)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  /// Pressure Converter
  func testHpaIsMbar() throws {

    let input: Double = 16
    let output: Double = 16

    let result = sut.convertPressure(value: input, unit: .mbar)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func testHpaToAtm() throws {

    let input: Double = 196.1
    let output: Double = 0.2

    let result = sut.convertPressure(value: input, unit: .atm)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test100Hpais75MmHg() throws {

    let input: Double = 100
    let output: Double = 75

    let result = sut.convertPressure(value: input, unit: .mmHg)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

  func test75Hpais2InHg() throws {

    let input: Double = 75
    let output: Double = 2.22

    let result = sut.convertPressure(value: input, unit: .inHg)

    XCTAssertEqual(output, result, accuracy: 0.01)
  }

}
