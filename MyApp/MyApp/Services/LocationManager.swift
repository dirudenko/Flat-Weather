//
//  LocationManager.swift
//  MyApp
//
//  Created by Dmitry on 03.02.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: AnyObject {
  var manager: CLLocationManager? { get }
  func checkServiceIsEnabled() -> Bool
  func checkLocationAuth() -> Bool?
  func deleteCurrentCity()
  func loadCurrentCity() -> MainInfo?
  func saveCurrentCity(_ userLocation: SearchModel)
}

final class LocationManager: NSObject, LocationManagerProtocol {

  var manager: CLLocationManager?
  var coreDataManager = CoreDataManager(modelName: "MyApp")

  override init() {
    super.init()
    _ = checkServiceIsEnabled()
    _ = checkLocationAuth()
  }

  func checkServiceIsEnabled() -> Bool {
    if CLLocationManager.locationServicesEnabled() {
      print("Enabled")
      manager = CLLocationManager()
      if #available(iOS 14.0, *) {
        manager?.desiredAccuracy = kCLLocationAccuracyReduced
      } else {
        manager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
      }
      manager?.requestWhenInUseAuthorization()
      // manager?.requestLocation()
      return true
    } else {
      print("Disabled")
      return false
    }
  }

  func checkLocationAuth() -> Bool? {
    guard let manager = manager else { return false }
    var status: Bool?
    if #available(iOS 14.0, *) {
      switch manager.authorizationStatus {
      case .notDetermined:
        manager.requestWhenInUseAuthorization()
      case .restricted:
        print("Your location is restridcted")
        status = false
      case .denied:
        print("Your location is denied")
        status = false
      case .authorizedAlways, .authorizedWhenInUse:
        status = true
      @unknown default:
        break
      }
    }
    return status
  }

  func deleteCurrentCity() {
    coreDataManager.cityResultsPredicate = NSPredicate(format: "name CONTAINS %@", "Current Location")
    coreDataManager.loadSavedData()
    guard let object = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return }
    coreDataManager.removeDataFromMainWeather(object: object)
  }

  func loadCurrentCity() -> MainInfo? {
    coreDataManager.cityResultsPredicate = NSPredicate(format: "name CONTAINS %@", "Current Location")
    coreDataManager.loadSavedData()
    guard let object = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return nil }
    return object
  }

  func saveCurrentCity(_ userLocation: SearchModel) {
    coreDataManager.saveToList(city: userLocation, isCurrentLocation: true)
  }

}
