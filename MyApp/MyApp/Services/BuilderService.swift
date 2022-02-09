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
  private static let settingsObserver = SettingsObserver()
  private static let locationManager = LocationManager()

  static func buildRootViewController() -> UINavigationController {
    var viewController = UIViewController()
    var navigationController = UINavigationController()

    if locationManager.checkServiceIsEnabled() && coreDataManager.entityIsEmpty() {
      viewController = LocationViewController()
      navigationController = UINavigationController(rootViewController: viewController)
    } else {
    if coreDataManager.entityIsEmpty() {
      viewController = buildSearchViewController()
      navigationController = UINavigationController(rootViewController: viewController)
    } else {
      viewController = buildPageViewController()
      navigationController = UINavigationController(rootViewController: viewController)
    }
    }
    navigationController.checkSettings()
    navigationController.setToolbarHidden(true, animated: false)
    return navigationController
  }

  static func buildPageViewController(at index: Int = 0) -> CityListPageViewController {
    coreDataManager.cityResultsPredicate = nil
    coreDataManager.loadSavedData()
    let list = coreDataManager.fetchedResultsController.fetchedObjects ?? []
    let vc = CityListPageViewController(for: list, index: index, locationManager: locationManager, coreDataManager: coreDataManager)
    return vc
  }

  static func buildMainWeatherViewController(city: MainInfo) -> MainWeatherViewController {
    let viewModel = MainWeatherViewModel(for: city, networkManager: networkManager, coreDataManager: coreDataManager, observer: settingsObserver)
    let viewController = MainWeatherViewController(viewModel: viewModel)
    return viewController
  }

  static func buildSearchViewController() -> UIViewController {
    let searchViewCellModel = SearchViewCellModel(networkManager: networkManager, coreDataManager: coreDataManager)
    let viewController = SearchViewController(searchViewCellModel: searchViewCellModel)
    return viewController
  }

  static func buildSettingsViewController() -> SettingsViewController {
    let viewModel = SettingsViewModel(observer: settingsObserver)
    let viewController = SettingsViewController(viewModel: viewModel)
    return viewController
  }

}
