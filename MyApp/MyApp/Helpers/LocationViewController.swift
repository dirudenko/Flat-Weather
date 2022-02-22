//
//  LocationViewController.swift
//  MyApp
//
//  Created by Dmitry on 03.02.2022.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {
  
  private var location: LocationManager?
  private let currentLocationLabel = NSLocalizedString("currentLocationLabel", comment: "Current Location Label")
  private var userLocation: SearchModel
  private let gradient = Constants.Design.gradient
  
  init(location: LocationManager?) {
    self.location = location
    userLocation = SearchModel(name: currentLocationLabel, localNames: nil, lat: 0, lon: 0, country: "Current Country", state: nil)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.insertSublayer(gradient, at: 0)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let isServiceEnabled = location?.checkServiceIsEnabled() else { return }
    if isServiceEnabled == true {
      location?.manager?.delegate = self
      location?.manager?.startUpdatingLocation()
    } else {
      let viewController = BuilderService.buildSearchViewController()
      navigationController?.pushViewController(viewController, animated: false)
    }
  }
  
  override func viewDidLayoutSubviews() {
    gradient.frame = self.view.bounds
    
  }
}
extension LocationViewController: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard let checkLocationAuth = location?.checkLocationAuth() else { return }
    if !checkLocationAuth {
      let viewController = BuilderService.buildSearchViewController()
      navigationController?.pushViewController(viewController, animated: false)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      self.location?.manager?.stopUpdatingLocation()
      userLocation.lat = location.coordinate.latitude
      userLocation.lon = location.coordinate.longitude
      self.location?.saveCurrentCity(userLocation)
      let viewController = BuilderService.buildPageViewController()
      navigationController?.pushViewController(viewController, animated: false)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if let error = error as? CLError {
      switch error {
      case CLError.locationUnknown:
        print("location unknown")
        let viewController = BuilderService.buildSearchViewController()
        navigationController?.pushViewController(viewController, animated: false)
      case CLError.denied:
        print("denied")
      default:
        print("other Core Location error")
      }
    } else {
      print("other error:", error.localizedDescription)
    }
  }
}
