//
//  Temperature.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import Foundation

enum Temperature: Int, CustomStringConvertible, Codable, CaseIterable {
  case Celcius
  case Fahrenheit
  
  var description: String {
    switch self {
    case .Celcius: return "°C"
    case .Fahrenheit: return "°F"
    }
  }
}
