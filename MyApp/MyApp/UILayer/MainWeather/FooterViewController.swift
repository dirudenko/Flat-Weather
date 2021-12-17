//
//  FooterViewController.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class FooterViewController: UIViewController {
  
  let weatherView = HourlyWeatherView()
  let loadingVC = LoadingViewController()
  private let networkManager = NetworkManager()
  private var hourlyWeather: HourlyWeather?
  
  override func loadView() {
    super.loadView()
    self.view = weatherView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    add(loadingVC)
    weatherView.collectionView.dataSource = self
    weatherView.collectionView.delegate = self
    weatherView.collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
    view.backgroundColor = UIColor(named: "backgroundColor")
    getHourlyWeather(for: MockData.mockCity)
    weatherView.dateLabel.text = Date().dateFormatter().capitalizedFirstLetter
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let footerFrame = CGRect(x: 0, y: 0, width: 390, height: 140)
    loadingVC.view.frame = footerFrame
  }
  
  private func getHourlyWeather(for city: CurrentWeather) {
    let lon = city.coord.lon
    let lat = city.coord.lat
    
    networkManager.getHourlyWeather(lon: lon, lat: lat) { result in
      switch result {
      case .success(let weather):
       // print(weather)
        DispatchQueue.main.async {
          self.hourlyWeather = weather
          self.weatherView.collectionView.reloadData()
          self.loadingVC.remove()
        }
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }
}

extension FooterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyWeather?.hourly.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell
    else { return UICollectionViewCell() }
    if let model = hourlyWeather {
      cell.configure(with: model, index: indexPath.row)
    }
    return cell
  }
}
