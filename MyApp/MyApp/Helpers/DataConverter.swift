//
//  DataConverter.swift
//  MyApp
//
//  Created by Dmitry on 24.01.2022.
//

import Foundation

final class DataConverter {

  func convertTemperature(value: Double, unit: Temperature) -> Double {
    switch unit {
    case .Celcius:
      let temp = Measurement(value: value, unit: UnitTemperature.fahrenheit)
      return temp.converted(to: .celsius).value
    case .Fahrenheit:
      let temp = Measurement(value: value, unit: UnitTemperature.celsius)
      return temp.converted(to: .fahrenheit).value
    }
  }
  

}
