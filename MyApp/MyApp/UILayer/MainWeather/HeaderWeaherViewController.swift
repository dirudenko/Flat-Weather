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
  
  override func loadView() {
    super.loadView()
    self.view = weatherView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   // getWeather(for: "Moscow")
    weatherView.collectionView.dataSource = self
    weatherView.collectionView.delegate = self
    weatherView.collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
  // add(loadingVC)
    weatherView.configure(with: MockData.mockCity)
  }
    
  func getWeather(for city: String) {
    networkManager.getWeaher(city: city) { result in
      switch result {
      case .success(let city):
        print(city)
        DispatchQueue.main.async {
          self.city = city
          self.weatherView.configure(with: city)
          self.weatherView.collectionView.reloadData()
        }
        
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }
  
  
}

extension HeaderWeaherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //return city != nil ? 4 : 0
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell
         // let model = city
           else { return UICollectionViewCell() }
    cell.configure(with: MockData.mockCity, index: indexPath.row)
    return cell
  }
}

