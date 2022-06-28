//
//  SearchViewCellModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation
import CoreData

protocol SearchViewCellModelProtocol: AnyObject {
  func configureCell(with model: SearchModel) -> String
  var searchCityName: String { get }
}

final class SearchViewCellModel: SearchViewCellModelProtocol {
  var searchCityName: String {
    return city.name + " " + city.country
  }
  
  // MARK: - Private variables
  private var city: SearchModel
  // MARK: - Initialization
  init(with city: SearchModel) {
    self.city = city
  }
  // MARK: - Public functions
  /// получениие объектов из списка сохраненных городов
  func configureCell(with model: SearchModel) -> String {
    let cityName = model.name
    let cityCountry = model.country
    let label = cityName + " " + cityCountry
    return label
  }
}
