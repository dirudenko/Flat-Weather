//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  
  private(set) var headerWeaherViewController = HeaderWeatherViewController()
  private var headerWeatherViewHeightSmall: NSLayoutConstraint?
  private var headerWeatherViewHeightBig: NSLayoutConstraint?
  
  private var footerWeaherViewController = FooterViewController()
  private let forcatsButton = Button()
  
  private var weeklyWeatherView = WeeklyWeatherView()
  private var weeklyWeatherViewTopSmall: NSLayoutConstraint?
  private var weeklyWeatherViewTopBig: NSLayoutConstraint?
  
  private var fetchedCityList: MainInfo
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  private var isPressed = false
  private let id: Int
  
  private let networkManager = NetworkManager()

  
  init(for list: MainInfo) {
    self.fetchedCityList = list
    id = Int(fetchedCityList.id)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIViewController lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // self.navigationItem.backBarButtonItem?.isEnabled = false
    view.backgroundColor = .systemBackground
    //let id = Int(fetchedCityList.id)
    
    //add(headerWeaherViewController!)
    //add(footerWeaherViewController)
    view.addSubview(headerWeaherViewController.view)
    view.addSubview(footerWeaherViewController.view)
    view.addSubview(weeklyWeatherView)
    setupConstraints()
    
    let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
    let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
    
    swipeGestureRecognizerDown.direction = .down
    swipeGestureRecognizerUp.direction = .up
    view.addGestureRecognizer(swipeGestureRecognizerDown)
    view.addGestureRecognizer(swipeGestureRecognizerUp)
    fetchDataFromCoreData()
    getCityWeather()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    headerWeaherViewController.view.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    headerWeaherViewController.view.layer.masksToBounds = true
    
    
  }
  
  private func fetchDataFromCoreData() {
    self.coreDataManager.cityResultsPredicate = NSPredicate(format: "id == %i", self.id)
    self.coreDataManager.loadSavedData()
    guard let data = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return }
    self.headerWeaherViewController.weatherView.configure(with: data)
    self.headerWeaherViewController.currentWeather = data
    self.headerWeaherViewController.weatherView.collectionView.reloadData()
    }
  
  private func getCityWeather() {
    let lon = fetchedCityList.lon
    let lat = fetchedCityList.lat
        guard
          let correctedLon = Double(String(format: "%.2f", lon)),
          let correctedLat = Double(String(format: "%.2f", lat))
        else { return }
    networkManager.getWeather(lon: correctedLon, lat: correctedLat) {[weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let weather):
        DispatchQueue.main.async {
        //  print(weather)
         
          self.coreDataManager.cityResultsPredicate = NSPredicate(format: "id == %i", self.id)
          self.coreDataManager.loadSavedData()
          let city = self.coreDataManager.fetchedResultsController.fetchedObjects?.first
          self.coreDataManager.configureTopView(from: weather, list: city)
          self.coreDataManager.configureBottomView(from: weather, list: city)
          self.headerWeaherViewController.weatherView.configure(with: city!)
          self.headerWeaherViewController.currentWeather = city
          self.headerWeaherViewController.weatherView.collectionView.reloadData()
          
          self.footerWeaherViewController.hourlyWeather = weather.hourly
          self.footerWeaherViewController.weatherView.collectionView.reloadData()
          self.weeklyWeatherView.model = weather
          self.weeklyWeatherView.weeklyListTableView.reloadData()
          self.headerWeaherViewController.loadingVC.remove()
          self.footerWeaherViewController.loadingVC.remove()
  //        self.coreDataManager.cityListPredicate = NSPredicate(format: "id == %i", self.cityId)
  //        self.coreDataManager.loadSavedData()
  //        let city = self.coreDataManager.fetchedResultsController.fetchedObjects?.first
  //        self.coreDataManager.configureTopView(from: weather, list: city)
  //        self.coreDataManager.configureBottomView(from: weather, list: city)
  //        self.coreDataManager.saveContext()
  //
  //        self.loadingVC.remove()
  //        self.currentWeather = weather
  //        self.weatherView.configure(with: weather)
  //        self.weatherView.collectionView.reloadData()
        }
        
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }

  
  
  @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
    
    switch sender.direction {
    case .up:
      headerWeaherViewController.weatherView.changeConstraints(isPressed: true)
      
      headerWeatherViewHeightBig?.isActive = false
      headerWeatherViewHeightSmall?.isActive = true
      
      weeklyWeatherViewTopBig?.isActive = false
      weeklyWeatherViewTopSmall?.isActive = true
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    case .down:
      headerWeaherViewController.weatherView.changeConstraints(isPressed: false)
      
      headerWeatherViewHeightSmall?.isActive = false
      headerWeatherViewHeightBig?.isActive = true
      
      weeklyWeatherViewTopSmall?.isActive = false
      weeklyWeatherViewTopBig?.isActive = true
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    default: break
    }
  }
}



extension MainWeatherViewController {
  private func setupConstraints() {
    headerWeaherViewController.view.translatesAutoresizingMaskIntoConstraints = false
    footerWeaherViewController.view.translatesAutoresizingMaskIntoConstraints = false
    weeklyWeatherView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      
      
      weeklyWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor),
      weeklyWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor),
      weeklyWeatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      headerWeaherViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      headerWeaherViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      headerWeaherViewController.view.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .width)),
      
      footerWeaherViewController.view.topAnchor.constraint(equalTo: headerWeaherViewController.view.bottomAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      footerWeaherViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      footerWeaherViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      footerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 140, to: .height))
    ])
    
    weeklyWeatherViewTopBig = weeklyWeatherView.topAnchor.constraint(equalTo: view.bottomAnchor)
    weeklyWeatherViewTopBig?.isActive = true
    weeklyWeatherViewTopSmall = weeklyWeatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 587, to: .height))
    
    headerWeatherViewHeightBig = headerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 565, to: .height))
    headerWeatherViewHeightBig?.isActive = true
    headerWeatherViewHeightSmall = headerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .height))
    
  }
}


