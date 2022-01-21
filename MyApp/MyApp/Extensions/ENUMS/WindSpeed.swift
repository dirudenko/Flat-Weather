//
//  WindSpeed.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import Foundation

enum WindSpeed: Int, Settings, CaseIterable {
  case kmh
  case milh
  case ms
  
  var description: String {
    switch self {
    case .kmh: return "km/h"
    case .milh: return "mil/h"
    case .ms: return "m/s"
    }
  }
}
