//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  
  private(set) var currentWeatherView = CurrentWeatherView()
  private var headerWeatherViewHeightSmall: NSLayoutConstraint?
  private var headerWeatherViewHeightBig: NSLayoutConstraint?
  
  private var hourlyWeatherView = HourlyWeatherView()
  private let forcatsButton = Button()
  
  private var weeklyWeatherView = WeeklyWeatherView()
  private var weeklyWeatherViewTopSmall: NSLayoutConstraint?
  private var weeklyWeatherViewTopBig: NSLayoutConstraint?
  
  private var fetchedCity: MainInfo
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  private var isPressed = false
  
  private let networkManager = NetworkManager()

  
  init(for list: MainInfo) {
    self.fetchedCity = list
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIViewController lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    let data = fetchDataFromCoreData()
    configureCurrentWeather(with: data)
    getCityWeather()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    //TODO: сделать проверку времени раз в час для повторного запроса в сеть
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    currentWeatherView.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    currentWeatherView.layer.masksToBounds = true
  }
  
  private func setupLayouts() {
    view.backgroundColor = .systemBackground
    view.addSubview(currentWeatherView)
    view.addSubview(hourlyWeatherView)
    view.addSubview(weeklyWeatherView)
    setupConstraints()
    currentWeatherView.delegate = self
    let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
    let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
    
    swipeGestureRecognizerDown.direction = .down
    swipeGestureRecognizerUp.direction = .up
    view.addGestureRecognizer(swipeGestureRecognizerDown)
    view.addGestureRecognizer(swipeGestureRecognizerUp)
  }
  
 /// Получение последних сохраненных данных из кордаты и их вывод на экран
  private func fetchDataFromCoreData() -> MainInfo? {
    let id = Int(fetchedCity.id)
    self.coreDataManager.cityResultsPredicate = NSPredicate(format: "id == %i", id)
    self.coreDataManager.loadSavedData()
    guard let data = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return nil }
    return data
    
    }
  /// запрос в сеть для получения всех актуальных погодных данных
  private func getCityWeather() {
    let lon = fetchedCity.lon
    let lat = fetchedCity.lat
        guard
          let correctedLon = Double(String(format: "%.2f", lon)),
          let correctedLat = Double(String(format: "%.2f", lat))
        else { return }
    networkManager.getWeather(lon: correctedLon, lat: correctedLat) {[weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let weather):
        DispatchQueue.main.async {
          
          let city = self.fetchDataFromCoreData()
          self.coreDataManager.configureTopView(from: weather, list: city)
          self.coreDataManager.configureBottomView(from: weather, list: city)
          
          self.configureCurrentWeather(with: city)
          self.configureHourlyWeather(with: weather)
          
         
        }
        
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }

  private func configureCurrentWeather(with data: MainInfo?) {
    guard let data = data else { return }
    self.currentWeatherView.configure(with: data)
    self.currentWeatherView.setCurrentWeather(data)
    self.currentWeatherView.loadingVC.makeInvisible()
    self.currentWeatherView.collectionView.reloadData()
  }
  
  private func configureHourlyWeather(with data: WeatherModel) {
    self.hourlyWeatherView.setHourlyWeatherModel(with: data.hourly)
    self.hourlyWeatherView.collectionView.reloadData()
    self.weeklyWeatherView.setWeatherModel(with: data)
    self.weeklyWeatherView.weeklyListTableView.reloadData()
    
    self.hourlyWeatherView.loadingVC.makeInvisible()
  }
  
  @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
    
    switch sender.direction {
    case .up:
      currentWeatherView.changeConstraints(isPressed: true)
      
      headerWeatherViewHeightBig?.isActive = false
      headerWeatherViewHeightSmall?.isActive = true
      
      weeklyWeatherViewTopBig?.isActive = false
      weeklyWeatherViewTopSmall?.isActive = true
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    case .down:
      currentWeatherView.changeConstraints(isPressed: false)
      
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
    currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
    hourlyWeatherView.translatesAutoresizingMaskIntoConstraints = false
    weeklyWeatherView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      weeklyWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor),
      weeklyWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor),
      weeklyWeatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      currentWeatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      currentWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      currentWeatherView.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .width)),
      
      hourlyWeatherView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      hourlyWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      hourlyWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      hourlyWeatherView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 140, to: .height))
    ])
    
    weeklyWeatherViewTopBig = weeklyWeatherView.topAnchor.constraint(equalTo: view.bottomAnchor)
    weeklyWeatherViewTopBig?.isActive = true
    weeklyWeatherViewTopSmall = weeklyWeatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 587, to: .height))
    
    headerWeatherViewHeightBig = currentWeatherView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 565, to: .height))
    headerWeatherViewHeightBig?.isActive = true
    headerWeatherViewHeightSmall = currentWeatherView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .height))
  }
}

extension MainWeatherViewController: HeaderButtonsProtocol {
  func optionsButtonTapped() {
    print("Options")
  }
  
  func plusButtonTapped() {
//    isPressed = !isPressed
//    headerWeaherViewController.weatherView.changeConstraints(isPressed: isPressed)
//    if isPressed {
//      headerWeatherViewHeightBig?.isActive = false
//      headerWeatherViewHeightSmall?.isActive = true
//
//      weeklyWeatherViewTopBig?.isActive = false
//      weeklyWeatherViewTopSmall?.isActive = true
//      UIView.animate(withDuration: 0.3) {
//        self.view.layoutIfNeeded()
//      }
//    } else {
//      headerWeatherViewHeightSmall?.isActive = false
//      headerWeatherViewHeightBig?.isActive = true
//
//      weeklyWeatherViewTopSmall?.isActive = false
//      weeklyWeatherViewTopBig?.isActive = true
//      UIView.animate(withDuration: 0.3) {
//        self.view.layoutIfNeeded()
//      }
//    }
//  }
//}
//    headerWeaherViewController.remove()
//    footerWeaherViewController.remove()
//    searchViewController = SearchViewController()
//    add(searchViewController!)
  let searchViewController = SearchViewController()
  navigationController?.pushViewController(searchViewController, animated: true)
 }
}

