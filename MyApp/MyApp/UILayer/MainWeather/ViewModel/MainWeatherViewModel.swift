//
//  MainWeatherViewModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

protocol MainWeatherViewModelProtocol: AnyObject {
  var updateViewData: ((MainViewData) ->())? { get set }
  var networkManager: NetworkManagerProtocol { get }
  var coreDataManager: CoreDataManagerResultProtocol? { get }
  func startFetch()
  func loadWeather()
  func checkDate() -> Bool
}
final class MainWeatherViewModel: MainWeatherViewModelProtocol {
  // MARK: - Private types
  private let dataConverter = DataConverter()
  // MARK: - Public types
  var networkManager: NetworkManagerProtocol
  var updateViewData: ((MainViewData) -> ())?
  var coreDataManager: CoreDataManagerResultProtocol?
  var fetchedCity: MainInfo
  weak var observer: SettingsObserver?
  // MARK: - Initialization
  init(for list: MainInfo, networkManager: NetworkManagerProtocol,
       coreDataManager: CoreDataManagerResultProtocol,
       observer: SettingsObserver) {
    updateViewData?(.initial)
    self.coreDataManager = coreDataManager
    self.networkManager = networkManager
    self.fetchedCity = list
    self.observer = observer
    self.observer?.register(observer: self)
  }
  // MARK: - Public functions
  func startFetch() {
    updateViewData?(.fetching(fetchedCity))
  }
  /// загрузка погодных данных с сети
  func loadWeather() {
    updateViewData?(.loading)
    guard
      let correctedLon = fetchedCity.lon.reduceDigits(to: 2),
      let correctedLat = fetchedCity.lat.reduceDigits(to: 2)
    else { return }
    networkManager.getWeather(lon: correctedLon, lat: correctedLat) {  result in
     // guard let self = self else { return }
      switch result {
      case .success(let weather):
        DispatchQueue.main.async {
          self.updateCoreData(model: weather, context: self.fetchedCity)
          let result = self.convertData(data: self.fetchedCity, weather: weather)
          switch result {
          case .success(let convertedWeather):
            self.updateCoreData(model: convertedWeather, context: self.fetchedCity)
            self.updateViewData?(.success(self.fetchedCity))
          case .failure(_): self.updateViewData?(.failure)
          }
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
    if (currentTimestamp - timestamp) > 1800 {
      return true
    } else {
      return false
    }
  }
  
  /// конвертирование заруженных данных, в выбранный тип

  func convertData(data: MainInfo, weather: WeatherModel?) -> Result<WeatherModel, NetworkErrors> {
    /// конвертирование температуры
    guard var weather = weather else {
      return .failure(.failed)
    }
    ///конвертирование скорости ветра
    switch data.unitTypes?.windType {
      /// km/h
    case 0:
      /// from Celsius
      if data.unitTypes?.tempType == 0 {
        weather.current.windSpeed = dataConverter.convertWindSpeed(value: data.bottomWeather?.wind ?? 0, from: .ms, to: .kmh)
      }
      /// from Fahrenheit
      if data.unitTypes?.tempType == 1 {
        weather.current.windSpeed = dataConverter.convertWindSpeed(value: data.bottomWeather?.wind ?? 0, from: .milh, to: .kmh)
      }
      /// mil/h
    case 1 :
      /// from Celsius
      if data.unitTypes?.tempType == 0 {
        
        weather.current.windSpeed = dataConverter.convertWindSpeed(value: data.bottomWeather?.wind ?? 0, from: .ms, to: .milh)
      }
      /// from Fahrenheit
      if data.unitTypes?.tempType == 1 {
        break
      }

      /// m/s
    case 2:
      /// from Celsius
      if data.unitTypes?.tempType == 0 {
        
       break
      }
      /// from Fahrenheit
      if data.unitTypes?.tempType == 1 {
        weather.current.windSpeed = dataConverter.convertWindSpeed(value: data.bottomWeather?.wind ?? 0, from: .milh, to: .ms)
      }
    default: break
    }
    
    /// конвертирование давления
    switch data.unitTypes?.pressureType {
      ///mBar
    case 0:
      weather.current.pressure = Int(dataConverter.convertPressure(value: Double((data.bottomWeather?.pressure ?? 0)), unit: .mbar))
      ///atm
    case 1:
      weather.current.pressure = Int(dataConverter.convertPressure(value: Double((data.bottomWeather?.pressure ?? 0)), unit: .atm))
      ///mmHg
    case 2:
      weather.current.pressure = Int(dataConverter.convertPressure(value: Double((data.bottomWeather?.pressure ?? 0)), unit: .mmHg))
      /// inHg
    case 3:
      weather.current.pressure = Int(dataConverter.convertPressure(value: Double((data.bottomWeather?.pressure ?? 0)), unit: .inHg))
      /// hPa default
    case 4:
      break
    default: break
    }
    return .success(weather)
  }
  // MARK: - Private functions

  /// Обновление КорДаты после запроса в сеть
  private func updateCoreData(model: WeatherModel, context: MainInfo) {
    coreDataManager?.configureTopView(from: model, list: context)
    coreDataManager?.configureBottomView(from: model, list: context)
    coreDataManager?.configureHourly(from: model, list: context)
    coreDataManager?.configureWeekly(from: model, list: context)
    coreDataManager?.updateUnitTypes(list: context)
  }
}

// MARK: - Observer delegate
extension MainWeatherViewModel: SubcribeSettings {
  func settingsChanged(unit: Settings, type: UnitOptions) {
    DispatchQueue.main.async {
      self.coreDataManager?.updateUnitTypes(list: self.fetchedCity)
      self.loadWeather()
    }
  }
}

