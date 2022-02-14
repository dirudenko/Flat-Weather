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
    let atmLabel = NSLocalizedString("atmLabel", comment: "atm Label")
    let hpaLabel = NSLocalizedString("hpaLabel", comment: "hpa Label")
    let inHqLabel = NSLocalizedString("inHqLabel", comment: "inHq Label")
    let mbarLabel = NSLocalizedString("mbarLabel", comment: "mbar Label")
    let mmHgLabel = NSLocalizedString("mmHgLabel", comment: "mmHq Label")
    switch self {
    case .atm: return atmLabel
    case .hPa: return hpaLabel
    case .inHg: return inHqLabel
    case .mbar: return mbarLabel
    case .mmHg: return mmHgLabel
    }
  }
}
