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
  var cityNamePredicate: NSPredicate?
  
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
  
  
  lazy var fetchedResultsController: NSFetchedResultsController<CitiListCD> = {
    let request = CitiListCD.createFetchRequest()
    request.fetchBatchSize = 20
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    
    controller.fetchRequest.predicate = cityNamePredicate
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
    }
  }
  
  
  func loadSavedData() {
    fetchedResultsController.fetchRequest.predicate = cityNamePredicate
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  /// Проверка наналичие данных в БД
  func entityIsEmpty() -> Bool {
    let request = CitiListCD.createFetchRequest()
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
  
  /// Конфигурация списка городов
  func configure(json: CitiList) {
    let entity = NSEntityDescription.entity(forEntityName: "CitiListCD",
                                            in: managedContext)!
    let list = CitiListCD(entity: entity, insertInto: managedContext)
    list.id = Int64(json.id)
    list.name = json.name
    list.lat = json.coord.lat
    list.lon = json.coord.lon
    list.country = json.country
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

 
  
  

