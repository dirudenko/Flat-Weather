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
  
}

//protocol CoreDataManagerListProtocol: CoreDataManagerProtocol {
//  func loadListData()
//  func entityIsEmpty() -> Bool
//  func saveToList(city: CityList)
//  func configure(json: CitiList)
//  var fetchedListController: NSFetchedResultsController<CityList> { get }
//}

protocol CoreDataManagerResultProtocol: CoreDataManagerProtocol {
  func loadSavedData()
  func configureTopView(from data: WeatherModel, list: MainInfo?)
  func configureBottomView(from data: WeatherModel, list: MainInfo?)
  var fetchedResultsController: NSFetchedResultsController<MainInfo> { get }
  func configureHourly(from data: WeatherModel, list: MainInfo?)
  func configureWeekly(from data: WeatherModel, list: MainInfo?)
  func saveToList(city: SearchModel)
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
    //container.viewContext.shouldDeleteInaccessibleFaults = true
    //container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()
  
  /// список добавленных пользователем городов
  lazy var fetchedResultsController: NSFetchedResultsController<MainInfo> = {
    let request = MainInfo.createFetchRequest()
    request.fetchBatchSize = 20
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    
    //controller.fetchRequest.predicate = cityResultsPredicate
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
  
  
  /// Проверка наналичие данных в БД
  //  func entityIsEmpty() -> Bool {
  //    let request = CityList.createFetchRequest()
  //    do {
  //      let results = try managedContext.fetch(request)
  //      if results.isEmpty {
  //        return true
  //      } else {
  //        return false
  //      }
  //    } catch {
  //      return false
  //    }
  //  }
  
  /// Сохранение добавленного города в КорДату
  func saveToList(city: SearchModel) {
    let entity = NSEntityDescription.entity(forEntityName: "MainInfo",
                                            in: managedContext)!
    let list = MainInfo(entity: entity, insertInto: managedContext)
    list.id = Int64(city.lat + city.lon)
    list.name = city.name
    list.lat = city.lat
    list.lon = city.lon
    list.country = city.country
    list.date = Date()
    saveContext()
  }
  
  func configureWeekly(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "Weekly",
                                            in: managedContext)!
    
    for (index, item) in data.daily.enumerated() {
      let weather = Weekly(entity: entity, insertInto: managedContext)
      weather.tempDay = Int16(item.temp.day)
      weather.tempNight = Int16(item.temp.night)
      weather.date = Int64(item.dt)
      weather.iconId = Int16(item.weather.first?.id ?? 0)
      weather.rain = Int16((item.pop ?? 0) * 100)
      list?.insertIntoWeeklyWeather(weather, at: index)
      weather.weather = list
    }
    saveContext()
  }
  
  func configureHourly(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "Hourly",
                                            in: managedContext)!
    
    for (index, item) in data.hourly.enumerated() {
      let weather = Hourly(entity: entity, insertInto: managedContext)
      weather.temp = Int16(item.temp)
      weather.fellsLike = Int16(item.feelsLike)
      weather.date = Int64(item.dt)
      weather.iconId = Int16(item.weather.first?.id ?? 0)
      weather.rain = Int16((item.pop ?? 0) * 100)
      list?.insertIntoHourlyWeather(weather, at: index)
      weather.weather = list
    }
    saveContext()  
  }
  
  /// Конфигурация верхнего бара с текущими погодными данными
  func configureTopView(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "TopBar",
                                            in: managedContext)!
    let weather = TopBar(entity: entity, insertInto: managedContext)
    weather.temperature = Int16(data.current.temp)
    weather.date = Int64(data.current.dt)
    weather.iconId = Int16(data.current.weather.first?.id ?? 0)
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
    weather.rain = Int16((data.current.pop ?? 0) * 100)
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





