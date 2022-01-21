//
//  SettingsSections.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import Foundation

protocol SectionType: CustomStringConvertible {
  var containsType: String { get }
}

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

enum UnitOptions: Int, CaseIterable, SectionType {
  
  case temperature
  case wind
  case pressure
  
  var containsType: String {
    switch self {
    case .temperature:
      let temperature: Temperature? = UserDefaultsManager.get(forKey: "Temperature")
      return temperature?.description ?? "Error"
    case .wind:
      let wind: WindSpeed? = UserDefaultsManager.get(forKey: "Wind")
      return wind?.description ?? "Error"
    case .pressure:
      let pressure: Pressure? = UserDefaultsManager.get(forKey: "Pressure")
      return pressure?.description ?? "Error"
    }
  }
  
  var description: String {
    switch self {
    case .temperature: return "Temperature unit"
    case .wind: return "Wind speed unit"
    case .pressure: return "Atmospheric pressure unit"
    }
  }
}

enum ExtraOptions: Int, CaseIterable, SectionType {
    
  case about
  case privacy
  
  var containsType: String {
    switch self {
    case .about: return ""
    case .privacy: return ""
    }
  }
  
  var description: String {
    switch self {
    case .about: return "About"
    case .privacy: return "Privacy policy"
    }
  }
  
}
