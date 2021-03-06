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
  private var location: LocationManagerProtocol?
  private let coreDataManager: CoreDataManagerResultProtocol
  // MARK: - Private variables
  /// Индекс города, показанного на экране
  private var currentIndex: Int
  private let currentLocationLabel = NSLocalizedString("currentLocationLabel", comment: "Current Location Label")
  private var userLocation: SearchModel?
  // MARK: - Initialization
  init(for list: [MainInfo], index: Int, locationManager: LocationManagerProtocol?, coreDataManager: CoreDataManagerResultProtocol) {
    self.list = list
    self.currentIndex = index
    self.location = locationManager
    self.coreDataManager = coreDataManager
    userLocation = SearchModel(name: currentLocationLabel, localNames: nil, lat: 0, lon: 0, country: "Current Country", state: nil)
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
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
    guard let isServiceEnabled = location?.checkLocationAuth() else { return }
    if isServiceEnabled == true {
      location?.manager?.delegate = self
      location?.manager?.startUpdatingLocation()
    }
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
      let viewController = BuilderService.buildMainWeatherViewController(city: $0)
      cityPage.append(viewController)
    }
    setViewControllers([cityPage[currentIndex]], direction: .forward, animated: false, completion: nil)
    self.navigationItem.setHidesBackButton(true, animated: false)
  }
}

// MARK: - UIViewController delegates

extension CityListPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let mainWeatherViewController = viewController as? MainWeatherViewController,
      let currentIndex = cityPage.firstIndex(of: mainWeatherViewController) else { return nil }
    if currentIndex == 0 {
      return nil
    } else {
      return cityPage[currentIndex - 1]
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let mainWeatherViewController = viewController as? MainWeatherViewController,
      let currentIndex = cityPage.firstIndex(of: mainWeatherViewController) else { return nil }
    if currentIndex < cityPage.count - 1 {
      return cityPage[currentIndex + 1]
    } else {
      return nil
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let viewControllers = pageViewController.viewControllers,
          let mainWeatherViewController = viewControllers[0] as? MainWeatherViewController,
     let currentIndex = cityPage.firstIndex(of: mainWeatherViewController) else { return }
    pageControl.currentPage = currentIndex
    pageControl.isHidden = false
  }

  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    pageControl.isHidden = true
  }
}
// MARK: - LocationManagerDelegate delegates
extension CityListPageViewController: CLLocationManagerDelegate {

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard let checkLocationAuth = location?.checkLocationAuth() else { return }
    /// проверка на случай если пользователь запретил геолокацию для приложения. Текущий город будет удален
    if !checkLocationAuth {
      location?.deleteCurrentCity()
      let viewController = BuilderService.buildRootViewController()
      viewController.modalPresentationStyle = .fullScreen
      present(viewController, animated: false, completion: nil)
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      /// изменение геопозиции при использовании приложения
      guard var userLocation = userLocation else { return }
      userLocation.lat = location.coordinate.latitude
      userLocation.lon = location.coordinate.longitude
      self.location?.saveCurrentCity(userLocation)

    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    
  }

}
