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
  var cityListPredicate: NSPredicate? { get set }
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
  
  func loadListData()
  func entityIsEmpty() -> Bool
  func saveToList(city: CityList)
  func configure(json: CitiList)
  var fetchedListController: NSFetchedResultsController<CityList> { get }
}


class CoreDataManager: CoreDataManagerResultProtocol {
  
   var modelName: String
  /// предикат для пользовательских городов
  var cityResultsPredicate: NSPredicate?
  /// предикат для всех городов
  var cityListPredicate: NSPredicate?
  
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
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    
    controller.fetchRequest.predicate = cityResultsPredicate
    do {
      try controller.performFetch()
    } catch {
      print(error.localizedDescription)
    }
    
    return controller
  }()
  /// список всех городов из JSON
  lazy var fetchedListController: NSFetchedResultsController<CityList> = {
    let request = CityList.createFetchRequest()
    request.fetchBatchSize = 20
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    
   // controller.fetchRequest.predicate = cityListPredicate
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
  /// загрузка всех городов
  func loadListData() {
    fetchedListController.fetchRequest.predicate = cityListPredicate
    do {
      try fetchedListController.performFetch()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  /// Проверка наналичие данных в БД
  func entityIsEmpty() -> Bool {
    let request = CityList.createFetchRequest()
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
  func saveToList(city: CityList) {
    let entity = NSEntityDescription.entity(forEntityName: "MainInfo",
                                             in: managedContext)!
    let list = MainInfo(entity: entity, insertInto: managedContext)
    list.id = city.id
    list.name = city.name
    list.lat = city.lat
    list.lon = city.lon
    list.country = city.country
    list.date = Date()
    saveContext()
  }
  
  /// добавление всех городов в кордату
  func configure(json: CitiList) {
    let entity = NSEntityDescription.entity(forEntityName: "CityList",
                                            in: managedContext)!
    let list = CityList(entity: entity, insertInto: managedContext)
    list.id = Int64(json.id)
    list.name = json.name
    list.lat = json.coord.lat
    list.lon = json.coord.lon
    list.country = json.country
  }
  
  /// Конфигурация верхнего бара с текущими погодными данными
  func configureTopView(from data: WeatherModel, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "TopBar",
                                             in: managedContext)!
    let weather = TopBar(entity: entity, insertInto: managedContext)
    weather.temperature = data.current.temp
    weather.date = Int64(data.current.dt)
    weather.iconId = Int16(data.current.weather.first?.id ?? 0)
    weather.desc = data.current.weather.first?.weatherDescription
    weather.citiList = list
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
    weather.rain = Int16(data.current.pop ?? 0 * 100)
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

 
  
  

