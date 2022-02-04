//
//  CityListPageViewController.swift
//  MyApp
//
//  Created by Dmitry on 24.12.2021.
//

import UIKit
import CoreLocation

class CityListPageViewController: UIPageViewController {
  
  // MARK: - Private types
  private let pageControl = UIPageControl()
  /// Список городов, сохраненных в БД
  private var list: [MainInfo]
  /// Массив контроллеров с городами из list с прогнозами погоды
  private var cityPage = [MainWeatherViewController]()
  private let observer: SearchObserver
  private let gps = LocationManager()
  let coreDataManager = CoreDataManager(modelName: "MyApp")
  // MARK: - Private variables
  /// Индекс города, показанного на экране
  private var currentIndex: Int
  private var userLocation = SearchModel(name: "Current Location", localNames: nil, lat: 0, lon: 0, country: "Current Country", state: nil)
  

  // MARK: - Initialization
  init(for list: [MainInfo], index: Int, observer: SearchObserver) {
    self.list = list
    self.currentIndex = index
    self.observer = observer
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    observer.register(observer: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - UIViewController lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPageController()
    configurePageControl()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if gps.checkServiceIsEnabled(){
      gps.manager?.delegate = self
      gps.manager?.startUpdatingLocation()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let pageFrame = CGRect(x: view.frame.width / 2 - pageControl.frame.width / 2,
                           y: adapted(dimensionSize: 105, to: .height),
                           width: pageControl.frame.width,
                           height: adapted(dimensionSize: 8, to: .height))
    pageControl.frame = pageFrame
  }
  
  deinit {
    print("CityListPageViewController deinit")
  }
  
  // MARK: - Private functions
  
  private func configurePageControl() {
    pageControl.numberOfPages = list.count
    pageControl.currentPage = currentIndex
    pageControl.pageIndicatorTintColor = .black
    pageControl.currentPageIndicatorTintColor = .white
    pageControl.hidesForSinglePage = true
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pageControl)
    pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
  }
  
  @objc private func pageControlTapped(_ sender: UIPageControl) {
    setViewControllers([cityPage[sender.currentPage]], direction: .forward, animated: true, completion: nil)
  }
  
  private func setupPageController() {
    self.dataSource = self
    self.delegate = self
    list.forEach {
      let vc = BuilderService.buildMainWeatherViewController(city: $0)
      cityPage.append(vc)
    }
    setViewControllers([cityPage[currentIndex]], direction: .forward, animated: false, completion: nil)
    self.navigationItem.setHidesBackButton(true, animated: false)
  }
}


// MARK: - UIViewController delegates

extension CityListPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = cityPage.firstIndex(of: viewController as! MainWeatherViewController) else { return nil }
    if currentIndex == 0 {
      return nil
    } else {
      return cityPage[currentIndex - 1]
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = cityPage.firstIndex(of: viewController as! MainWeatherViewController) else { return nil }
    if currentIndex < cityPage.count - 1 {
      return cityPage[currentIndex + 1]
    } else {
      return nil
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let viewControllers = pageViewController.viewControllers else { return }
    guard let currentIndex = cityPage.firstIndex(of: viewControllers[0] as! MainWeatherViewController) else { return }
    pageControl.currentPage = currentIndex
    pageControl.isHidden = false
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    pageControl.isHidden = true
  }
}

extension CityListPageViewController: SubcribeSearch {
  func delete(at index: Int) {
//    let vc  = BuilderService.buildPageViewController()
//    let navigationController = UINavigationController(rootViewController: vc)
//    navigationController.setViewControllers([vc], animated: true)
//    navigationController.modalPresentationStyle = .fullScreen
//    present(navigationController, animated: false)
  //  let vc = BuilderService.buildPageViewController()
  //  navigationController?.pushViewController(vc, animated: true)
   // let vc = BuilderService.buildPageViewController()
  //  navigationController?.setViewControllers([vc], animated: true)
  }
}

extension CityListPageViewController: CLLocationManagerDelegate {
 
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard let checkLocationAuth = gps.checkLocationAuth() else { return }
    /// проверка на случай если пользователь запретил геолокацию для приложения. Текущий город будет удален
    if !checkLocationAuth {
      gps.deleteCurrentCity()
      let vc = BuilderService.buildRootViewController()
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: false, completion: nil)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      gps.manager?.stopUpdatingLocation()
      /// изменение геопозиции при использовании приложения
      userLocation.lat = location.coordinate.latitude
      userLocation.lon = location.coordinate.longitude
      
//      gps.deleteCurrentCity()
//      gps.saveCurrentCity(userLocation)
//      guard let city = gps.loadCurrentCity() else { return }
//              cityPage.first?.viewModel.loadWeather()
//      let vc = BuilderService.buildRootViewController()
//      vc.modalPresentationStyle = .fullScreen
//      present(vc, animated: false, completion: nil)
      
//      coreDataManager.saveToList(city: userLocation, isCurrentLocation: true)
//      coreDataManager.saveContext()
//      coreDataManager.cityResultsPredicate = nil
//      coreDataManager.loadSavedData()
//      list = coreDataManager.fetchedResultsController.fetchedObjects ?? []
//      dataSource = nil
//      dataSource = self
    }
    }
   
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
}
