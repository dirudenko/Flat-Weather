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
  case celcius
  case fahrenheit

  var description: String {
    let celciusLabel = NSLocalizedString("celciusLabel", comment: "celcius Label")
    let fahrenheitLabel = NSLocalizedString("fahrenheitLabel", comment: "fahrenheit Label")

    switch self {
    case .celcius: return celciusLabel
    case .fahrenheit: return fahrenheitLabel
    }
  }
}
