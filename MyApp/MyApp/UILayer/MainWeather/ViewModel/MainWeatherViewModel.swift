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
  
  var networkManager: NetworkManagerProtocol
  var updateViewData: ((MainViewData) -> ())?
  var coreDataManager: CoreDataManagerResultProtocol?
  private var fetchedCity: MainInfo
  weak var observer: SettingsObserver?
  private let dataConverter = DataConverter()
  
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
  
  func startFetch() {
    updateViewData?(.fetching(fetchedCity))
  }
  /// Обновление КорДаты после запроса в сеть
  private func updateCoreData(model: WeatherModel, context: MainInfo) {
    self.coreDataManager?.configureTopView(from: model, list: context)
    self.coreDataManager?.configureBottomView(from: model, list: context)
    self.coreDataManager?.configureHourly(from: model, list: context)
    self.coreDataManager?.configureWeekly(from: model, list: context)
    coreDataManager?.saveContext()
    self.coreDataManager?.updateUnitTypes(list: context)
  }
  /// загрузка погодных данных с сети
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
          self.updateCoreData(model: weather, context: self.fetchedCity)
          let result = self.convertData(data: self.fetchedCity, weather: weather)
          switch result {
          case .success(let weather):
            self.updateCoreData(model: weather, context: self.fetchedCity)
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
    if (currentTimestamp - timestamp) > 3600 {
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
    switch data.unitTypes?.tempType {
      ///Celsius default
    case 0:
      break
      ///Fahrenheit
    case 1:
      weather.current.temp = dataConverter.convertTemperature(value: data.topWeather?.temperature ?? 0, unit: .Fahrenheit)
      guard let hourlyWeather: [Hourly] = data.hourlyWeather?.toArray() else { return .failure(.noData) }
      for (index, _) in weather.hourly.enumerated() {
        weather.hourly[index].temp = dataConverter.convertTemperature(value: hourlyWeather[index].temp, unit: .Fahrenheit)
        weather.hourly[index].feelsLike = dataConverter.convertTemperature(value: hourlyWeather[index].feelsLike, unit: .Fahrenheit)
      }
        guard let weeklyWeather: [Weekly] = data.weeklyWeather?.toArray() else { return .failure(.noData) }
      for (index, _) in weather.daily.enumerated() {
        weather.daily[index].temp.day = dataConverter.convertTemperature(value: weeklyWeather[index].tempDay, unit: .Fahrenheit)
        weather.daily[index].temp.night = dataConverter.convertTemperature(value: weeklyWeather[index].tempNight, unit: .Fahrenheit)
      }
    default: fatalError()
    }
    
    ///конвертирование скорости ветра
    switch data.unitTypes?.windType {
      /// km/h
    case 0:
      weather.current.windSpeed = dataConverter.convertWindSpeed(value: data.bottomWeather?.wind ?? 0, unit: .kmh)
      /// mil/h
    case 1 :
      weather.current.windSpeed = dataConverter.convertWindSpeed(value: data.bottomWeather?.wind ?? 0, unit: .milh)

      /// m/s default
    case 2: break
    default: fatalError()
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
    default: fatalError()
    }
    
    
    return .success(weather)
  }
  
}

/// Observer delegate
extension MainWeatherViewModel: SubcribeSettings {
  func settingsChanged(unit: Settings, type: UnitOptions) {
    coreDataManager?.updateUnitTypes(list: fetchedCity)
    loadWeather()
  }
}

