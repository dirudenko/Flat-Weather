//
//  MainWeatherViewModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

protocol MainWeatherViewModelProtocol {
  var updateViewData: ((ViewData) ->())? { get set }
  var networkManager: NetworkManagerProtocol { get }
  func startFetch()
  func loadWeather()
}

final class MainWeatherViewModel: MainWeatherViewModelProtocol {
  
  var networkManager: NetworkManagerProtocol
  var updateViewData: ((ViewData) -> ())?
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  private var fetchedCity: MainInfo
  
  init(for list: MainInfo, networkManager: NetworkManagerProtocol) {
    updateViewData?(.initial)
    self.networkManager = networkManager
    self.fetchedCity = list
  }
  
  func startFetch() {
    guard let data = fetchDataFromCoreData() else { return }
    updateViewData?(.loading(data))
  }
  
  private func updateCoreData(model: WeatherModel) {
    let city = self.fetchDataFromCoreData()
    self.coreDataManager.configureTopView(from: model, list: city)
    self.coreDataManager.configureBottomView(from: model, list: city)
  }
  
  func loadWeather() {
    let lon = fetchedCity.lon
    let lat = fetchedCity.lat
    guard
      let correctedLon = Double(String(format: "%.2f", lon)),
      let correctedLat = Double(String(format: "%.2f", lat))
    else { return }
    networkManager.getWeather(lon: correctedLon, lat: correctedLat) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let weather):
        DispatchQueue.main.async {
          self.updateCoreData(model: weather)
          let city = self.fetchDataFromCoreData()
          self.updateViewData?(.success(weather,city))
        }
        
      case .failure(let error):
        print(error.rawValue)
        DispatchQueue.main.async {
          self.updateViewData?(.failure)
        }
      }
    }
  }
  
  
  private func fetchDataFromCoreData() -> MainInfo? {
    let id = Int(fetchedCity.id)
    self.coreDataManager.cityResultsPredicate = NSPredicate(format: "id == %i", id)
    self.coreDataManager.loadSavedData()
    guard let data = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return nil }
    return data
  }
}


