//
//  ViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class HeaderWeaherViewController: UIViewController {
  
  private let networkManager = NetworkManager()
  private var city: CityWeather?
  let weatherView = HeaderWeatherView()
  let loadingVC = LoadingViewController()
  var mockData = MockData()
  //var weatherCollectionView = HeaderWeatherCollectionView()
  
  override func loadView() {
    super.loadView()
    self.view = weatherView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   // getWeather(for: "Moscow")
    //add(loadingVC)
//    view.alpha = 0
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//      self.loadingVC.remove()
//      self.view.alpha = 1
//    }
    let config =  UIImage.SymbolConfiguration.preferringMulticolor()
    weatherView.weatherImage.image = UIImage(systemName: "sun.max.fill", withConfiguration: config)
    weatherView.citiNameLabel.text = mockData.mockCity.name
    weatherView.dateLabel.text = "TODAY"
    weatherView.temperatureLabel.text = "24 C"
    weatherView.conditionLabel.text = "Heavy Rain"
   // addCollectionView()
  }
  
//  private func addCollectionView() {
//    weatherView.addSubview(weatherCollectionView)
//
//    NSLayoutConstraint.activate([
//
//      weatherCollectionView.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 444),
//      weatherCollectionView.leftAnchor.constraint(equalTo: weatherView.leftAnchor, constant: 16),
//      weatherCollectionView.widthAnchor.constraint(equalToConstant: 326),
//      weatherCollectionView.heightAnchor.constraint(equalToConstant: 105),
//      ])
//  }
  
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

