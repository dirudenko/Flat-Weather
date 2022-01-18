//
//  Double+ Ext.swift
//  MyApp
//
//  Created by Dmitry on 17.01.2022.
//

import Foundation

extension Double {
  /// уменьшение количества цифр после запятой до digits
  func reduceDigits(to digits: Int) -> Double? {
    return Double(String(format: "%.\(digits)f", self))
  }
}
