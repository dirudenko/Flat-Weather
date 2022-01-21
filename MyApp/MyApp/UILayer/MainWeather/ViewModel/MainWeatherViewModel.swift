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
    let result = convertData(data: data)
    coreDataManager.saveContext()
    switch result {
    case .success(let data):
      updateViewData?(.fetching(data))
      UserDefaultsManager.set(false,forKey: "UnitChange")
    case .failure(_):
      updateViewData?(.failure)
    }
    
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
    if (currentTimestamp - timestamp) > 3 {
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
  
  private func convertData(data: MainInfo) -> Result<MainInfo, NetworkErrors> {
    guard let temperature: Temperature = UserDefaultsManager.get(forKey: "Temperature"),
    let wind: WindSpeed = UserDefaultsManager.get(forKey: "Wind"),
          let pressure: Pressure = UserDefaultsManager.get(forKey: "Pressure") else { return .failure(.noData) }
    let isChanged = UserDefaults.standard.object(forKey: "UnitChange") as? Bool
    var convertedData = data

    if isChanged == true {
    switch temperature {
    case .Celcius:
      convertedData.topWeather?.temperature = Int16(data.topWeather!.temperature * 5 / 9 - 32)
    case .Fahrenheit:
      convertedData.topWeather?.temperature = Int16(data.topWeather!.temperature * 9 / 5 + 32)
    }
    
    switch wind {
    case .kmh:
      break
    case .milh:
      break
    case .ms:
      break
    }
    
    switch pressure {
    case .mbar:
      break
    case .atm:
      break
    case .mmHg:
      break
    case .inHg:
      break
    case .hPa:
      break
    }
    }
    return .success(convertedData)
  }
  
}


