//
//  Pressure.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import Foundation

enum Pressure: Int, Settings, CaseIterable {
  case mbar
  case atm
  case mmHg
  case inHg
  case hPa
  
  var description: String {
    switch self {
    case .atm: return "atm"
    case .hPa: return "hPa"
    case .inHg: return "inHg"
    case .mbar: return "mbar"
    case .mmHg: return "mmHg"
    }
  }
}

