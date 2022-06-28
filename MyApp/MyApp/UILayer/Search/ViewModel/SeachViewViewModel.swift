//
//  SeachViewViewModel.swift
//  MyApp
//
//  Created by Dmitry on 28.06.2022.
//

import Foundation
import CoreData

protocol SearchViewViewModelProtocol: AnyObject {
  
  func cellViewModel(for indexPath: IndexPath) -> SearchViewCellModelProtocol?
  
  var updateViewData: ((SearchViewData) -> Void)? { get set }
  var networkManager: NetworkManagerProtocol { get }
  var coreDataManager: CoreDataManagerResultProtocol { get }
  func setModel(with model: [SearchModel])
  func numberOfSections(at tableView: TableViewCellTypes) -> Int
  func numberOfRows() -> Int
  func getObjects(at section: Int) -> MainInfo?
  func searchText(text: String)
  func setCity(index: Int, for tableView: TableViewCellTypes) -> [MainInfo]
  func removeObject(at index: Int)
}

final class SearchViewViewModel: SearchViewViewModelProtocol {
  // MARK: - Private variables
  var networkManager: NetworkManagerProtocol
  var coreDataManager: CoreDataManagerResultProtocol
  var updateViewData: ((SearchViewData) -> Void)?
  
  private var cityList: [SearchModel]?
  
  func cellViewModel(for indexPath: IndexPath) -> SearchViewCellModelProtocol? {
    guard let city = cityList?[indexPath.row] else { fatalError("Can't get city") }
    return SearchViewCellModel(with: city)
  }
  
  // MARK: - Initialization
  init(networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerResultProtocol) {
    updateViewData?(.initial)
    self.coreDataManager = coreDataManager
    self.networkManager = networkManager
  }
  // MARK: - Public functions
  /// получение количества секций для таблиц
  func numberOfSections(at tableView: TableViewCellTypes) -> Int {
    switch tableView {
    case .cityListTableViewCell:
      coreDataManager.cityResultsPredicate = nil
      coreDataManager.loadSavedData()
      let sections = coreDataManager.fetchedResultsController.fetchedObjects?.count
      return  sections ?? 0
    case .searchTableViewCell:
      return 1
    default:
      return 0
    }
  }
  
  func numberOfRows() -> Int {
    return cityList?.count ?? 0
  }
  
  func setModel(with model: [SearchModel]) {
    cityList = model
  }
  /// получениие объектов из списка сохраненных городов
  func getObjects(at section: Int) -> MainInfo? {
    return coreDataManager.fetchedResultsController.fetchedObjects?[section]
  }
  
  func removeObject(at index: Int) {
    guard let object = getObjects(at: index) else { return }
    coreDataManager.removeDataFromMainWeather(object: object)
  }
  
  /// Передеча текста в качестве предиката для фетчРеквеста списка всех городов
  func searchText(text: String) {
    if text.count > 3 {
      networkManager.getCityName(name: text) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let weather):
          DispatchQueue.main.async {
            self.updateViewData?(.success(weather))
            print(weather)
          }
          
        case .failure(let error):
          DispatchQueue.main.async {
            self.updateViewData?(.failure(error.rawValue))
          }
        }
      }
    } else
    if text.isEmpty {
      self.updateViewData?(.initial)
    } else {
      self.updateViewData?(.load)
    }
  }
  
  func configureCell(index: Int) -> String {
    guard let model = cityList?[index] else { return "Error" }
    let cityName = model.name
    let cityCountry = model.country
    let label = cityName + " " + cityCountry
    return label
  }
  
  /// получение выбранного города в зависимости от таблицы для передачи в контроллер
  func setCity(index: Int, for tableView: TableViewCellTypes) -> [MainInfo] {
    switch tableView {
    case .cityListTableViewCell:
      return coreDataManager.fetchedResultsController.fetchedObjects ?? []
    case .searchTableViewCell:
      guard let model = cityList?[index] else { return [] }
      coreDataManager.saveToList(city: model, isCurrentLocation: false)
      coreDataManager.loadSavedData()
      return coreDataManager.fetchedResultsController.fetchedObjects ?? []
    default:
      return []
    }
  }
}
