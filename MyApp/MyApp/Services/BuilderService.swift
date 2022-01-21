//
//  BulderService.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import UIKit

final class BuilderService {
  
  private static let networkManager: NetworkManagerProtocol = NetworkManager()
  private static var coreDataManager: CoreDataManagerResultProtocol = CoreDataManager(modelName: "MyApp")
 
  static func buildRootViewController() -> UINavigationController {
    var viewController = UIViewController()
    var navigationController = UINavigationController()
    coreDataManager.loadSavedData()
    let list = coreDataManager.fetchedResultsController.fetchedObjects ?? []
    if list.isEmpty {
      viewController = buildSearchViewController()
      navigationController = UINavigationController(rootViewController: viewController)
    } else {
      viewController = CityListPageViewController(for: list, index: 0)
      navigationController = UINavigationController(rootViewController: viewController)
    }
    navigationController.setToolbarHidden(true, animated: false)
    return navigationController
  }

  static func buildPageViewController() -> CityListPageViewController {
    coreDataManager.cityResultsPredicate = nil
    coreDataManager.loadSavedData()
    let list = coreDataManager.fetchedResultsController.fetchedObjects ?? []
    let vc = CityListPageViewController(for: list, index: 0)
    return vc
  }
  
  static func buildMainWeatherViewController(city: MainInfo) -> MainWeatherViewController {
    let viewModel = MainWeatherViewModel(for: city, networkManager: networkManager, coreDataManager: coreDataManager)
    let viewController = MainWeatherViewController(viewModel: viewModel)
    return viewController
  }
  
  static func buildSearchViewController() -> UIViewController {
    let searchViewCellModel = SearchViewCellModel(networkManager: networkManager)
    let viewController = SearchViewController(searchViewCellModel: searchViewCellModel)
    return viewController
  }
  
  static func buildSettingsViewController() -> SettingsViewController {
    let viewModel = SettingsViewModel()
    let viewController = SettingsViewController(viewModel: viewModel)
    return viewController
  }
  
}
