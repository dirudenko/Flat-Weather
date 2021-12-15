//
//  ViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class MainWeaherViewController: UIViewController {
  
  private let networkManager = NetworkManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getWeather(for: "Moscow")
  }
  
  func getWeather(for city: String) {
    networkManager.getWeaher(city: city) { result in
      switch result {
      case .success(let city):
        print(city)
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }
  
  
}

