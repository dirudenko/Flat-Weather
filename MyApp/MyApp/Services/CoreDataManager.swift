//
//  CoreDataManager.swift
//  MyApp
//
//  Created by Dmitry on 18.12.2021.
//

import Foundation
import CoreData


class CoreDataManager {
  
  fileprivate let modelName: String
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
  
  
  lazy var fetchedResultsController: NSFetchedResultsController<MainInfo> = {
    let request = MainInfo.createFetchRequest()
    request.fetchBatchSize = 20
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    
    controller.fetchRequest.predicate = cityListPredicate
    do {
      try controller.performFetch()
    } catch {
      print(error.localizedDescription)
    }
    
    return controller
  }()
  
  lazy var fetchedListController: NSFetchedResultsController<List> = {
    let request = List.createFetchRequest()
    request.fetchBatchSize = 20
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
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
  
  func loadSavedData() {
    fetchedResultsController.fetchRequest.predicate = cityListPredicate
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func loadListData() {
    //fetchedResultsController.fetchRequest.predicate = cityListPredicate
    do {
      try fetchedListController.performFetch()
    } catch {
      print(error.localizedDescription)
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
  func saveToList(city: MainInfo) {
    let entity = NSEntityDescription.entity(forEntityName: "List",
                                             in: managedContext)!
    let list = List(entity: entity, insertInto: managedContext)
    list.id = city.id
    list.addToInList(city)
  }
  
  /// Конфигурация списка городов
  func configure(json: CitiList) {
    let entity = NSEntityDescription.entity(forEntityName: "MainInfo",
                                            in: managedContext)!
    let list = MainInfo(entity: entity, insertInto: managedContext)
    list.id = Int64(json.id)
    list.name = json.name
    list.lat = json.coord.lat
    list.lon = json.coord.lon
    list.country = json.country
  }
  
  /// Конфигурация верхнего бара с текущими погодными данными
  func configureTopView(from data: CurrentWeather, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "TopBar",
                                             in: managedContext)!
    let weather = TopBar(entity: entity, insertInto: managedContext)
    weather.temperature = data.main.temp
    weather.date = Int64(data.dt)
    weather.iconId = Int16(data.weather.first?.id ?? 0)
    weather.desc = data.weather.first?.weatherDescription
    weather.citiList = list
    weather.citiList?.name = data.name
  }
  
  /// Конфигурация collectionView бара с текущими погодными данными
  func configureBottomView(from data: CurrentWeather, list: MainInfo?) {
    let entity = NSEntityDescription.entity(forEntityName: "BottomBar",
                                             in: managedContext)!
    let weather = BottomBar(entity: entity, insertInto: managedContext)
    weather.wind = data.wind.speed
    weather.humidity = Int16(data.main.humidity)
    weather.pressure = Int16(data.main.pressure)
    weather.rain = Int16(data.clouds.all)
    weather.weather = list
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

 
  
  

