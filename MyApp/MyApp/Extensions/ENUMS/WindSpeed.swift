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
    let kmhLabel = NSLocalizedString("kmhLabel", comment: "kmh Label")
    let milhLabel = NSLocalizedString("milhLabel", comment: "milh Label")
    let msLabel = NSLocalizedString("msLabel", comment: "ms Label")

    switch self {
    case .kmh: return kmhLabel
    case .milh: return milhLabel
    case .ms: return msLabel
    }
  }
}
