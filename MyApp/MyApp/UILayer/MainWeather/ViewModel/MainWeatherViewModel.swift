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
  func checkSettings()
  func checkDate() -> Bool
  var fetchedCity: MainInfo {get}
}
// TODO: изменение значение по умолчанию при добавлении нового города. Иначе неправильно пересчитываются значения
final class MainWeatherViewModel: MainWeatherViewModelProtocol {
  
  var networkManager: NetworkManagerProtocol
  var updateViewData: ((MainViewData) -> ())?
  var coreDataManager: CoreDataManagerResultProtocol?
  var fetchedCity: MainInfo
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
    //checkSettings()
    updateViewData?(.fetching(fetchedCity))
  }
 /// Обновление КорДаты после запроса в сеть
  private func updateCoreData(model: WeatherModel, context: MainInfo) {
   // let city = fetchedCity
    self.coreDataManager?.configureTopView(from: model, list: context)
    self.coreDataManager?.configureBottomView(from: model, list: context)
    self.coreDataManager?.configureHourly(from: model, list: context)
    self.coreDataManager?.configureWeekly(from: model, list: context)
    coreDataManager?.saveContext()
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
          self.updateCoreData(model: weather, context: self.fetchedCity)
          self.updateViewData?(.success(self.fetchedCity))
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
  
  
//  private func fetchDataFromCoreData() -> MainInfo? {
//    let name = fetchedCity.name
//    self.coreDataManager.cityResultsPredicate = NSPredicate(format: "name == %@", name)
//    self.coreDataManager.loadSavedData()
//    guard let data = coreDataManager.fetchedResultsController.fetchedObjects?.first else {  return nil }
//    return data
//  }
  
 /// проверка настроек перед выводом на экран на наличие изменений относительно настроек по-умолчанию, которые сохранены в КорДате
  func checkSettings() {
    let temperature: Temperature? = UserDefaultsManager.get(forKey: "Temperature")
    let wind: WindSpeed? = UserDefaultsManager.get(forKey: "Wind")
    let pressure: Pressure? = UserDefaultsManager.get(forKey: "Pressure")
    if temperature == .Fahrenheit {
      let result = convertData(data: fetchedCity, type: .temperature)
      switch result {
      case .success(let data):
        fetchedCity = data
        updateViewData?(.fetching(fetchedCity))
       // coreDataManager.saveContext()
      case .failure(_):
        updateViewData?(.failure)
      }
    }
    
    switch wind {
    case .kmh:
      break
    case .milh:
      break
    default: break
    }
    
//    if wind == nil {
//      let wind: WindSpeed = .kmh
//      UserDefaultsManager.set(wind,forKey: "Wind")
//    }
//
//    if pressure == nil {
//      let pressure: Pressure = .mbar
//      UserDefaultsManager.set(pressure,forKey: "Pressure")
//    }
  }
 /// конвертирование данных по-умочалнию, сохраненных в КорДате, в выбранный тип
  private func convertData(data: MainInfo, type: UnitOptions) -> Result<MainInfo, NetworkErrors> {
    guard let temperature: Temperature = UserDefaultsManager.get(forKey: "Temperature"),
          let wind: WindSpeed = UserDefaultsManager.get(forKey: "Wind"),
          let pressure: Pressure = UserDefaultsManager.get(forKey: "Pressure") else
          { return .failure(.noData) }
    let convertedData = data
    print(fetchedCity.topWeather?.temperature)
    /// конвертирование температуры
    if type == .temperature {
    switch temperature {
    case .Celcius:
      convertedData.topWeather?.temperature = dataConverter.convertTemperature(value: data.topWeather!.temperature, unit: .Celcius)
      guard let convertedHourlyWeather: [Hourly] = convertedData.hourlyWeather?.toArray(),
      let hourlyWeather: [Hourly] = data.hourlyWeather?.toArray() else { return .failure(.noData) }
      for (index,item) in convertedHourlyWeather.enumerated() {
        item.temp = dataConverter.convertTemperature(value: hourlyWeather[index].temp, unit: .Celcius)
        item.fillsLike = dataConverter.convertTemperature(value: hourlyWeather[index].fillsLike, unit: .Celcius)
      }
    case .Fahrenheit:
      print(convertedData.name)
      convertedData.topWeather?.temperature = dataConverter.convertTemperature(value: data.topWeather!.temperature, unit: .Fahrenheit)
      guard let convertedHourlyWeather: [Hourly] = convertedData.hourlyWeather?.toArray(),
      let hourlyWeather: [Hourly] = data.hourlyWeather?.toArray() else { return .failure(.noData) }
      for (index,item) in convertedHourlyWeather.enumerated() {
        item.temp = dataConverter.convertTemperature(value: hourlyWeather[index].temp, unit: .Fahrenheit)
        item.fillsLike = dataConverter.convertTemperature(value: hourlyWeather[index].fillsLike, unit: .Fahrenheit)
      }
    }
    } else
    if type == .wind {
    
    switch wind {
    case .kmh:
      break
    case .milh:
      break
    case .ms:
      break
    }
    } else
    if type == .pressure {
    
    
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

/// Observer delegate
extension MainWeatherViewModel: SubcribeSettings {
  func settingsChanged(unit: Settings, type: UnitOptions) {
//    if dataModel == nil {
//      let data = fetchedCity
//      dataModel = data
//    }
    let result = convertData(data: fetchedCity, type: type)
    switch result {
    case .success(let data):
      fetchedCity = data
      updateViewData?(.fetching(fetchedCity))
     // coreDataManager.saveContext()
    case .failure(_):
      updateViewData?(.failure)
    }
  }
}

