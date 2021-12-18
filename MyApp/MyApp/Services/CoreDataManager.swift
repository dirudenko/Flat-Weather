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
  
  private lazy var storeContainer: NSPersistentContainer = {
    
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


class TestCoreDataManager: CoreDataManager {
//  private lazy var testStoreContainer: NSPersistentContainer = {
//    
//    let container = NSPersistentContainer(name: self.modelName)
//    container.loadPersistentStores { _, error in
//      if let error = error as NSError? {
//        print("Unresolved error \(error), \(error.userInfo)")
//      }
//    }
//    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//    container.viewContext.shouldDeleteInaccessibleFaults = true
//    container.viewContext.automaticallyMergesChangesFromParent = true
//    return container
//  }()
//  
//   lazy var testManagedContext: NSManagedObjectContext = {
//    return testStoreContainer.viewContext
//  }()
//  
//  lazy var testFetchedResultsController: NSFetchedResultsController<CitiListCD> = {
//    let request = CitiListCD.createFetchRequest()
//    request.fetchBatchSize = 20
//    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: testManagedContext, sectionNameKeyPath: nil, cacheName: nil)
//    
//    controller.fetchRequest.predicate = cityNamePredicate
//    do {
//      try controller.performFetch()
//    } catch {
//      print(error.localizedDescription)
//    }
//    return controller
//  }()
//  
//  override func saveContext () {
//    guard testManagedContext.hasChanges else { return }
//    
//    do {
//      try testManagedContext.save()
//    } catch let error as NSError {
//      print("Unresolved error \(error), \(error.userInfo)")
//    }
//  }
//  
//  
//  override func loadSavedData() {
//    testFetchedResultsController.fetchRequest.predicate = cityNamePredicate
//    do {
//      try testFetchedResultsController.performFetch()
//    } catch {
//      print(error.localizedDescription)
//    }
//  }
//  
//  override func configure(json: CitiList) {
//    let entity = NSEntityDescription.entity(forEntityName: "CitiListCD",
//                                            in: testManagedContext)!
//    let list = CitiListCD(entity: entity, insertInto: testManagedContext)
//    list.id = Int64(json.id)
//    list.name = json.name
//    list.lat = json.coord.lat
//    list.lon = json.coord.lon
//    list.country = json.country
//  }
  
 
  
  
}
