//
//  Date + dateformatter.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation

extension Date {
  
  func dateFormatter() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE | d MMM"
    let stringDate = formatter.string(from: self)
    return stringDate
  }
  
  func dateHourFormatter() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let stringDate = formatter.string(from: self)
    return stringDate
  }
  
}
