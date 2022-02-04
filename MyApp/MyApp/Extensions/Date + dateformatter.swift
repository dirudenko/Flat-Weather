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
    formatter.dateFormat = "EEEE | d MMM"
    formatter.locale = Locale(identifier: "en")
    let stringDate = formatter.string(from: self)
    return stringDate
  }
  
  func dateHourFormatter() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.locale = Locale(identifier: "en")
    let stringDate = formatter.string(from: self)
    return stringDate
  }
  
  func dateDayFormatter() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    formatter.locale = Locale(identifier: "en")
    let stringDate = formatter.string(from: self)
    return stringDate
  }
  
}
