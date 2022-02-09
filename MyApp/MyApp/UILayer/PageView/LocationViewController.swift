//
//  LocationViewController.swift
//  MyApp
//
//  Created by Dmitry on 03.02.2022.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {

  private let location = LocationManager()
  private var userLocation = SearchModel(name: "Current Location", localNames: nil, lat: 0, lon: 0, country: "Current Country", state: nil)
  private let gradient = Constants.Design.gradient
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.insertSublayer(gradient, at: 0)

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if location.checkServiceIsEnabled() {
      location.manager?.delegate = self
      location.manager?.startUpdatingLocation()
    }
  }

  override func viewDidLayoutSubviews() {
    gradient.frame = self.view.bounds

  }
}
extension LocationViewController: CLLocationManagerDelegate {

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard let checkLocationAuth = location.checkLocationAuth() else { return }
    if !checkLocationAuth {
      let viewController = BuilderService.buildSearchViewController()
      navigationController?.pushViewController(viewController, animated: false)
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      self.location.manager?.stopUpdatingLocation()
      userLocation.lat = location.coordinate.latitude
      userLocation.lon = location.coordinate.longitude
      self.location.saveCurrentCity(userLocation)
      let viewController = BuilderService.buildPageViewController()
      navigationController?.pushViewController(viewController, animated: false)
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }

}
