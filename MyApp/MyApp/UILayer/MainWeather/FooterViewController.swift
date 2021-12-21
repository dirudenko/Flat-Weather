//
//  FooterViewController.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

final class FooterViewController: UIViewController {
  
  private let weatherView = HourlyWeatherView()
  private let loadingVC = LoadingViewController()
  private let networkManager = NetworkManager()
  private var hourlyWeather: HourlyWeather?
  private let lat: Double
  private let lon: Double
  private let coreDataManager = CoreDataManager(modelName: "MyApp")

  
  init(lat: Double, lon: Double) {
    self.lat = lat
    self.lon = lon
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    let footerFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    loadingVC.view.frame = footerFrame
  }
  
  private func getHourlyWeather(for city: CurrentWeather) {
    guard 
    let correctedLon = Double(String(format: "%.2f", lon)),
    let correctedLat = Double(String(format: "%.2f", lat))
    else { return }
    
    
    //      let lon = city.coord.lon
    //    let lat = city.coord.lat
    
    networkManager.getHourlyWeather(lon: correctedLon, lat: correctedLat) { result in
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
