//
//  ViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class HeaderWeaherViewController: UIViewController {
  
  private let networkManager = NetworkManager()
  private var currentWeather: CurrentWeather?
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
    //add(loadingVC)
    weatherView.configure(with: MockData.mockCity)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let headerFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    loadingVC.view.frame = headerFrame
  }
  
    
  func getWeather(for city: String) {
    networkManager.getWeather(city: city) { result in
      switch result {
      case .success(let weather):
        //print(weather)
        DispatchQueue.main.async {
    
          self.loadingVC.remove()
          self.currentWeather = weather
          self.weatherView.configure(with: weather)
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

