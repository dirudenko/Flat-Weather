//
//  MainWeatherViewModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

protocol MainWeatherViewModelProtocol {
  var updateViewData: ((MainViewData) ->())? { get set }
  var networkManager: NetworkManagerProtocol { get }
  var coreDataManager: CoreDataManagerResultProtocol { get }
  func startFetch()
  func loadWeather()
  func checkDate() -> Bool
}

final class MainWeatherViewModel: MainWeatherViewModelProtocol {
  
  var networkManager: NetworkManagerProtocol
  var updateViewData: ((MainViewData) -> ())?
  var coreDataManager: CoreDataManagerResultProtocol
  private var fetchedCity: MainInfo
  
  init(for list: MainInfo, networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerResultProtocol) {
    updateViewData?(.initial)
    self.coreDataManager = coreDataManager
    self.networkManager = networkManager
    self.fetchedCity = list
  }
  
  func startFetch() {
    guard let data = fetchDataFromCoreData() else { return }
    updateViewData?(.fetching(data))
  }
  
  private func updateCoreData(model: WeatherModel) {
    let city = self.fetchDataFromCoreData()
    self.coreDataManager.configureTopView(from: model, list: city)
    self.coreDataManager.configureBottomView(from: model, list: city)
    self.coreDataManager.configureHourly(from: model, list: city)
    self.coreDataManager.configureWeekly(from: model, list: city)
  }
  
  func loadWeather() {
    updateViewData?(.loading)
    guard
      let correctedLon = fetchedCity.lon.reduceDigits(to: 2),
      let correctedLat = fetchedCity.lat.reduceDigits(to: 2)
    else { return }
    networkManager.getWeather(lon: correctedLon, lat: correctedLat) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let weather):
        DispatchQueue.main.async {
          self.updateCoreData(model: weather)
          guard let city = self.fetchDataFromCoreData() else { return }
          self.updateViewData?(.success(city))
        }
        
      case .failure(let error):
        print(error.rawValue)
        DispatchQueue.main.async {
          self.updateViewData?(.failure)
        }
      }
    }
  }
  /// проверка даты последнего обновления данных
  func checkDate() -> Bool {
    let currentTimestamp = Date().timeIntervalSince1970
    let timestamp = Double(fetchedCity.topWeather?.date ?? 0)
    if (currentTimestamp - timestamp) > 30 {
      return true
    } else {
      return false
    }
  }
  
  
  private func fetchDataFromCoreData() -> MainInfo? {
    let name = fetchedCity.name
    self.coreDataManager.cityResultsPredicate = NSPredicate(format: "name == %@", name)
    self.coreDataManager.loadSavedData()
    guard let data = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return nil }
    return data
  }
}


