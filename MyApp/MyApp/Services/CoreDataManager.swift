//
//  CoreDataManager.swift
//  MyApp
//
//  Created by Dmitry on 18.12.2021.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
  var modelName: String { get }
  var cityResultsPredicate: NSPredicate? { get set }
  func saveContext()
  func entityIsEmpty() -> Bool
  func loadSavedData()
  var fetchedResultsController: NSFetchedResultsController<MainInfo> { get }
  func removeDataFromMainWeather(object: MainInfo)
  func removeAllData()
}

// protocol CoreDataManagerListProtocol: CoreDataManagerProtocol {
//  func loadListData()
//  func entityIsEmpty() -> Bool
//  func saveToList(city: CityList)
//  func configure(json: CitiList)
//  var fetchedListController: NSFetchedResultsController<CityList> { get }
// }

protocol CoreDataManagerResultProtocol: CoreDataManagerProtocol {
  func configureTopView(from data: WeatherModel, list: MainInfo?)
  func configureBottomView(from data: WeatherModel, list: MainInfo?)
  func configureHourly(from data: WeatherModel, list: MainInfo?)
  func configureWeekly(from data: WeatherModel, list: MainInfo?)
  func saveToList(city: SearchModel, isCurrentLocation: Bool)
  func updateUnitTypes(list: MainInfo?)
}

class CoreDataManager: CoreDataManagerResultProtocol {

  var modelName: String
  /// предикат для пользовательских городов
  var cityResultsPredicate: NSPredicate?
  /// предикат для всех городов

  init(modelName: String) {
    self.modelName = modelName
  }

  fileprivate lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    container.viewContext.shouldDeleteInaccessibleFaults = true
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()

  /// список добавленных пользователем городов
  lazy var fetchedResultsController: NSFetchedResultsController<MainInfo> = {
    let request = MainInfo.createFetchRequest()
    request.fetchBatchSize = 20
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)

    controller.fetchRequest.predicate = cityResultsPredicate
    do {
      try controller.performFetch()
    } catch {
      print(error.localizedDescription)
    }

    return controller
  }()

  lazy var managedContext: NSManagedObjectContext = {
    return storeContainer.viewContext
  }()

  func saveContext () {
    guard managedContext.hasChanges else { return }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
      fatalError("Unresolved error \(error), \(error.userInfo)")
    }
  }

  /// загрузка пользовательских городов
  func loadSavedData() {
    fetchedResultsController.fetchRequest.predicate = cityResultsPredicate
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print(error.localizedDescription)
    }
  }

  func removeDataFromMainWeather(object: MainInfo) {
    fetchedResultsController.managedObjectContext.delete(object)
    saveContext()
  }
  
  func removeAllData() {
    let cities = fetchedResultsController.fetchedObjects
    if let cities = cities {
      for city in cities {
        city.managedObjectContext?.delete(city)
      }
    }
  }

  /// Проверка наналичие данных в БД
  func entityIsEmpty() -> Bool {
    let request = MainInfo.createFetchRequest()
    do {
      let results = try managedContext.fetch(request)
      if results.isEmpty {
        return true
      } else {
        return false
      }
    } catch {
      return false
    }
  }

  /// Сохранение добавленного города в КорДату
  func saveToList(city: SearchModel, isCurrentLocation: Bool) {
    let entity = NSEntityDescription.entity(forEntityName: "MainInfo",
                                            in: managedContext)!
    let list = MainInfo(entity: entity, insertInto: managedContext)

    list.id = isCurrentLocation ? 0 : Int64(city.lat + city.lon)
    let searchLanguage = NSLocalizedString("apiCallLanguage", comment: "search Language")
    
    let cityName = city.localNames?[searchLanguage]
    list.name = cityName ?? city.name
    list.lat = city.lat
    list.lon = city.lon
    list.country = city.country
    if isCurrentLocation {
      let date = Date(timeIntervalSince1970: 0)
      list.date = date
    } else {
      list.date = Date()
    }
    updateUnitTypes(list: list)
    saveContext()
  }

  func updateUnitTypes(list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "UnitsTypes",
                                            in: managedContext)!
    let units = UnitsTypes(entity: entity, insertInto: managedContext)
    guard let temperatureType: Temperature = UserDefaultsManager.get(forKey: "Temperature"),
          let windSpeedType: WindSpeed = UserDefaultsManager.get(forKey: "Wind"),
          let pressureType: Pressure = UserDefaultsManager.get(forKey: "Pressure") else { return }

    units.tempType = Int16(temperatureType.rawValue)
    units.windType = Int16(windSpeedType.rawValue)
    units.pressureType = Int16(pressureType.rawValue)
    list?.unitTypes = units
    // saveContext()
  }

  func configureWeekly(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "Weekly",
                                            in: managedContext)!

    for (index, item) in data.daily.enumerated() {
      let weather = Weekly(entity: entity, insertInto: managedContext)
      weather.tempDay = item.temp.day
      weather.tempNight = item.temp.night
      weather.date = Int64(item.dt)
      weather.iconId = item.weather.first?.icon ?? ""
      weather.pop = Int16((item.pop ?? 0) * 100)
      weather.name = list?.name ?? ""
      weather.id = Int16(index)
      list?.insertIntoWeeklyWeather(weather, at: index)
      weather.weather = list
    }
    // saveContext()
  }

  func configureHourly(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "Hourly",
                                            in: managedContext)!

    for (index, item) in data.hourly.enumerated() {
      let weather = Hourly(entity: entity, insertInto: managedContext)
      weather.temp = item.temp
      weather.feelsLike = item.feelsLike
      weather.date = Int64(item.dt)
      weather.iconId = item.weather.first?.icon ?? ""
      weather.pop = Int16((item.pop ?? 0) * 100)
      weather.name = list?.name ?? ""
      weather.id = Int16(index)
      list?.addToHourlyWeather(weather)
      weather.weather = list
    }
    // saveContext()
  }

  /// Конфигурация верхнего бара с текущими погодными данными
  func configureTopView(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "TopBar",
                                            in: managedContext)!
    let weather = TopBar(entity: entity, insertInto: managedContext)
    weather.temperature = data.current.temp
    weather.feelsLike = data.current.feelsLike
    weather.date = Int64(data.current.dt)
    weather.iconId = data.current.weather.first?.icon ?? ""
    weather.desc = data.current.weather.first?.weatherDescription
    weather.weather = list
    saveContext()
  }

  /// Конфигурация collectionView бара с текущими погодными данными
  func configureBottomView(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "BottomBar",
                                            in: managedContext)!
    let weather = BottomBar(entity: entity, insertInto: managedContext)
    weather.wind = data.current.windSpeed
    weather.humidity = Int16(data.current.humidity)
    weather.pressure = Int16(data.current.pressure)
    weather.pop = Int16((data.hourly.first?.pop ?? 0) * 100)
    weather.weather = list
    saveContext()
  }
}

/// Класс для тестирования КорДаты с инМемори хранением данных
class TestCoreDataManager: CoreDataManager {
  override init(modelName: String) {
    super.init(modelName: modelName)
    let container = NSPersistentContainer(
      name: self.modelName)
    container.persistentStoreDescriptions[0].url =
    URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError(
          "Unresolved error \(error), \(error.userInfo)")
      }
    }

    self.storeContainer = container
  }
}
