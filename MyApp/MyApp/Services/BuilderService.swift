//
//  BulderService.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import UIKit

final class BuilderService {
  
  private static let networkManager: NetworkManagerProtocol = NetworkManager()
  private static let coreDataManager: CoreDataManagerResultProtocol = CoreDataManager(modelName: "MyApp")
 
  
  static func buildRootViewController() -> UINavigationController {
    var viewController = UIViewController()
    var navigationController = UINavigationController()
    coreDataManager.loadSavedData()
    let list = coreDataManager.fetchedResultsController.fetchedObjects ?? []
    if list.isEmpty {
      viewController = buildSearchViewController()
      viewController.view.backgroundColor = UIColor(named: "backgroundColor")
      navigationController = UINavigationController(rootViewController: viewController)
    } else {
      viewController = CityListPageViewController(for: list, index: 0)
      navigationController = UINavigationController(rootViewController: viewController)
    }
    navigationController.setToolbarHidden(true, animated: false)
    return navigationController
  }

  static func buildMainWeatherViewController(city: MainInfo) -> MainWeatherViewController {
    let viewModel = MainWeatherViewModel(for: city, networkManager: networkManager, coreDataManager: coreDataManager)
    let viewController = MainWeatherViewController(viewModel: viewModel)
    return viewController
  }
  
  static func buildSearchViewController() -> UIViewController {
    let viewModel = SearchViewModel(networkManager: networkManager, coreDataManager: coreDataManager)
    let searchViewCellModel = SearchViewCellModel()
    let viewController = SearchViewController(viewModel: viewModel, searchViewCellModel: searchViewCellModel)
    return viewController
  }

}
