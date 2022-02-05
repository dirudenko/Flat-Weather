//
//  DataConverter.swift
//  MyApp
//
//  Created by Dmitry on 24.01.2022.
//

import Foundation

struct DataConverter {

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
  
  func convertWindSpeed(value: Double, from: WindSpeed, to: WindSpeed) -> Double {
    switch to {
    case .ms:
      switch from {
      case .kmh:
        let windSpeed = Measurement(value: value, unit: UnitSpeed.kilometersPerHour)
        return windSpeed.converted(to: .metersPerSecond).value
      case .milh:
        let windSpeed = Measurement(value: value, unit: UnitSpeed.milesPerHour)
        return windSpeed.converted(to: .metersPerSecond).value
      case .ms:
        return value
      }
    case .kmh:
      switch from {
      case .kmh:
        return value
      case .milh:
        let windSpeed = Measurement(value: value, unit: UnitSpeed.milesPerHour)
        return windSpeed.converted(to: .kilometersPerHour).value
      case .ms:
        let windSpeed = Measurement(value: value, unit: UnitSpeed.metersPerSecond)
        return windSpeed.converted(to: .kilometersPerHour).value
      }
    case .milh:
      switch from {
      case .kmh:
        let windSpeed = Measurement(value: value, unit: UnitSpeed.kilometersPerHour)
        return windSpeed.converted(to: .milesPerHour).value
      case .milh:
        return value
      case .ms:
        let windSpeed = Measurement(value: value, unit: UnitSpeed.metersPerSecond)
        return windSpeed.converted(to: .milesPerHour).value
      }
    }
  }
  
  func convertPressure(value: Double, unit: Pressure) -> Double {
    switch unit {
    case .mbar:
      let pressure = Measurement(value: value, unit: UnitPressure.hectopascals)
      return pressure.converted(to: .millibars).value
    case .atm:
      let pressure = value / 1013
      return pressure
    case .mmHg:
      let pressure = Measurement(value: value, unit: UnitPressure.hectopascals)
      return pressure.converted(to: .millimetersOfMercury).value
    case .inHg:
      let pressure = Measurement(value: value, unit: UnitPressure.hectopascals)
      return pressure.converted(to: .inchesOfMercury).value
    case .hPa:
      return value
    }
  }

}
