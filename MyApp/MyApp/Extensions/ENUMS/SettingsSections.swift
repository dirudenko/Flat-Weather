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

  case units
  case extra

  var description: String {
    let unitsLabel = NSLocalizedString("unitsLabel", comment: "")
    let extraLabel = NSLocalizedString("extraLabel", comment: "")
    switch self {
    case .units: return unitsLabel
    case .extra: return extraLabel
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
    let temperatureLabel = NSLocalizedString("temperatureUnitDescription", comment: "")
    let windLabel = NSLocalizedString("windUnitDescription", comment: "")
    let pressureLabel = NSLocalizedString("pressureUnitDescription", comment: "")
    switch self {
    case .temperature: return temperatureLabel
    case .wind: return windLabel
    case .pressure: return pressureLabel
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
    let aboutLabel = NSLocalizedString("aboutDescription", comment: "")
    let privacyLabel = NSLocalizedString("privacyDescription", comment: "")
    switch self {
    case .about: return aboutLabel
    case .privacy: return privacyLabel
    }
  }

}
