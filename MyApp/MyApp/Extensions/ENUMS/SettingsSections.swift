//
//  SettingsSections.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import Foundation
import UIKit

enum SettingsSections: Int, CaseIterable, CustomStringConvertible {
  
  case Units
  case Extra
  
  var description: String {
    switch self {
    case .Units: return "UNIT"
    case .Extra: return "EXTRA"
    }
  }
  
}

enum UnitOptions: Int, CaseIterable, CustomStringConvertible {
case temperature
case wind
case pressure
  
  var description: String {
    switch self {
    case .temperature: return "Temperature unit"
    case .wind: return "Wind speed unit"
    case .pressure: return "Atmospheric pressure unit"
    }
  }
}

enum ExtraOptions: Int, CaseIterable, CustomStringConvertible {
case about
case privacy
  
  var description: String {
    switch self {
    case .about: return "About"
    case .privacy: return "Privacy policy"
    }
  }
  
}
