//
//  ViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class MainWeaherViewController: UIViewController {
  
  private let networkManager = NetworkManager()
  private var city: CityWeather?
  let weatherView = MainWeatherView()
  let loadingVC = LoadingViewController()

  
  override func loadView() {
    super.loadView()
    self.view = weatherView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   // getWeather(for: "Moscow")
    add(loadingVC)
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.loadingVC.remove()
    }
    weatherView.weatherImage.image = UIImage(systemName: "sun.max")
    weatherView.citiNameLabel.text = "Moscow"
    weatherView.dateLabel.text = "TODAY"
    weatherView.temperatureLabel.text = "24 C"
    weatherView.conditionLabel.text = "Heavy Rain"
  }
  

  
  func getWeather(for city: String) {
    networkManager.getWeaher(city: city) { result in
      switch result {
      case .success(let city):
        print(city)
        self.city = city
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }
  
  
}

