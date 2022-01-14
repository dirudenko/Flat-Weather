//
//  Pressure.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import Foundation

//enum Pressure: String, Codable {
//  case mbar = "mbar"
//  case atm = "atm"
//  case mmHg = "mmHg"
//  case inHg = "inHg"
//  case hPa = "hPa"
//}

enum Pressure: Int, CustomStringConvertible, Codable, CaseIterable {
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

