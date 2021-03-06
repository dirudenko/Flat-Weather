//
//  SearchViewCellModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

protocol SearchViewCellModelProtocol: AnyObject {
  var searchCityName: String { get }
}

final class SearchViewCellModel: SearchViewCellModelProtocol {
  // MARK: - Private variables
  private var city: SearchModel
  // MARK: - Public variables
  var searchCityName: String {
    let searchLanguage = NSLocalizedString("apiCallLanguage", comment: "search Language")
    let localName = city.localNames?[searchLanguage] ?? city.name
    return localName + " " + city.country
  }
  
  // MARK: - Initialization
  init(with city: SearchModel) {
    self.city = city
  }
}
