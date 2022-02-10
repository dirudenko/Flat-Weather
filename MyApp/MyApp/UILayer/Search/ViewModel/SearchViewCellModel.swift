//
//  SearchViewCellModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation
import CoreData

protocol SearchViewCellModelProtocol {
  var updateViewData: ((SearchViewData) -> Void)? { get set }
  var networkManager: NetworkManagerProtocol { get }
  var coreDataManager: CoreDataManagerResultProtocol { get }
  func setSections(at tableView: TableViewCellTypes) -> Int
  func getObjects(at section: Int) -> MainInfo?
  func searchText(text: String)
  func setCity(model: SearchModel?, for tableView: TableViewCellTypes) -> [MainInfo]
  func removeObject(at index: Int)

}

final class SearchViewCellModel: SearchViewCellModelProtocol {
  // MARK: - Private variables
  var networkManager: NetworkManagerProtocol
  var coreDataManager: CoreDataManagerResultProtocol
  var updateViewData: ((SearchViewData) -> Void)?
  // MARK: - Initialization
  init(networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerResultProtocol) {
    updateViewData?(.initial)
    self.coreDataManager = coreDataManager
    self.networkManager = networkManager
  }
  // MARK: - Public functions
  /// получение количества секций для таблиц
  func setSections(at tableView: TableViewCellTypes) -> Int {
    switch tableView {
    case .cityListTableViewCell:
      coreDataManager.cityResultsPredicate = nil
      coreDataManager.loadSavedData()
      let sections = coreDataManager.fetchedResultsController.fetchedObjects?.count
      return  sections ?? 0
    case .standartTableViewCell:
      return 1
    default:
      return 0
    }
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
          }

        case .failure(let error):
          DispatchQueue.main.async {
            self.updateViewData?(.failure(error.rawValue))
          }
        }
      }
    } else if text.isEmpty {
      self.updateViewData?(.initial)
    } else {
      self.updateViewData?(.load)
    }
  }

  /// получение выбранного города в зависимости от таблицы для передачи в контроллер
  func setCity(model: SearchModel?, for tableView: TableViewCellTypes) -> [MainInfo] {
    switch tableView {
    case .cityListTableViewCell:
      return coreDataManager.fetchedResultsController.fetchedObjects ?? []
    case .standartTableViewCell:
      guard let model = model else { return [] }
      coreDataManager.saveToList(city: model, isCurrentLocation: false)
      coreDataManager.loadSavedData()
      return coreDataManager.fetchedResultsController.fetchedObjects ?? []
    default:
      return []
    }
  }
}
