//
//  Date + dateformatter.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation
/// форматирование даты в нужный формат на главном экране

extension Date {

  func dateFormatter() -> String {
    let formatter = DateFormatter()
    let searchLanguage = NSLocalizedString("apiCallLanguage", comment: "search Language")
    formatter.dateFormat = "EEEE | d MMM"
    formatter.locale = Locale(identifier: searchLanguage)
    let stringDate = formatter.string(from: self)
    return stringDate
  }

  func dateHourFormatter() -> String {
    let formatter = DateFormatter()
    let searchLanguage = NSLocalizedString("apiCallLanguage", comment: "search Language")
    formatter.dateFormat = "HH:mm"
    formatter.locale = Locale(identifier: searchLanguage)
    let stringDate = formatter.string(from: self)
    return stringDate
  }

  func dateDayFormatter() -> String {
    let formatter = DateFormatter()
    let searchLanguage = NSLocalizedString("apiCallLanguage", comment: "search Language")
    formatter.dateFormat = "EEEE"
    formatter.locale = Locale(identifier: searchLanguage)
    let stringDate = formatter.string(from: self)
    return stringDate
  }

}
