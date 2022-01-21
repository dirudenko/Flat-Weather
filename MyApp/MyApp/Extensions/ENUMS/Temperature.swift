//
//  Temperature.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import Foundation

protocol Settings: CustomStringConvertible, Codable {
  var description: String { get }
}

enum Temperature: Int, Settings, CaseIterable {
  case Celcius
  case Fahrenheit
  
  var description: String {
    switch self {
    case .Celcius: return "°C"
    case .Fahrenheit: return "°F"
    }
  }
}
