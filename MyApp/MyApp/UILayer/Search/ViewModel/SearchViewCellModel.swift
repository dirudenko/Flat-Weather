//
//  SearchViewCellModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation


protocol SearchViewCellModelProtocol {
  func setSections(at tableView: TableViewCellTypes) -> Int
  func setRows(at section: Int) -> Int
  func getObjects(at section: Int) -> MainInfo?
  func searchText(text: String)
  func setText(at index: IndexPath) -> String
  func setCity(at indexPath: IndexPath, for tableView: TableViewCellTypes) -> [MainInfo]
}

final class SearchViewCellModel: SearchViewCellModelProtocol {
  // MARK: - Private variables
  var coreDataManager = CoreDataManager(modelName: "MyApp")
  // MARK: - Public functions
  /// получение количества секций для таблиц
  func setSections(at tableView: TableViewCellTypes) -> Int {
    switch tableView {
    case .CityListTableViewCell:
      return coreDataManager.fetchedResultsController.fetchedObjects?.count ?? 0
    case .StandartTableViewCell:
      
      return coreDataManager.fetchedListController.sections?.count ?? 0
    default:
      return 0
    }
  }
  /// получение количества строк в таблице
  func setRows(at section: Int) -> Int {
    return coreDataManager.fetchedListController.fetchedObjects?.count ?? 0
  }
  /// получениие объектов из списка сохраненных городов
  func getObjects(at section: Int) -> MainInfo? {
    return coreDataManager.fetchedResultsController.fetchedObjects?[section]
  }
  
  /// Передеча текста в качестве предиката для фетчРеквеста списка всех городов
  func searchText(text: String) {
    coreDataManager.cityListPredicate = NSPredicate(format: "name CONTAINS %@", text)
    coreDataManager.loadListData()
  }
  /// получениие объектов из списка всех городов
  func setText(at index: IndexPath) -> String {
    return "\(coreDataManager.fetchedListController.object(at: index).name) \(coreDataManager.fetchedListController.object(at: index).country)"
  }
  
  /// получение выбранного города в зависимости от таблицы для передачи в контроллер
  func setCity(at indexPath: IndexPath, for tableView: TableViewCellTypes) -> [MainInfo] {
    switch tableView {
    case .CityListTableViewCell:
      return coreDataManager.fetchedResultsController.fetchedObjects ?? []
    case .StandartTableViewCell:
      let city = coreDataManager.fetchedListController.object(at: indexPath)
      coreDataManager.saveToList(city: city)
      coreDataManager.loadSavedData()
      return coreDataManager.fetchedResultsController.fetchedObjects ?? []
    default:
      return []
    }
  }
}
