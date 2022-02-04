//
//  SearchModel.swift
//  MyApp
//
//  Created by Dmitry on 17.01.2022.
//

import Foundation

struct SearchModel: Codable {
  let name: String
  let localNames: [String: String]?
  var lat, lon: Double
  let country: String
  let state: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case localNames = "local_names"
    case lat, lon, country
    case state
  }
}
