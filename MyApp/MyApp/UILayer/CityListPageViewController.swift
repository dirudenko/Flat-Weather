//
//  CityListPageViewController.swift
//  MyApp
//
//  Created by Dmitry on 24.12.2021.
//

import UIKit

class CityListPageViewController: UIPageViewController {
  
  private let pageControl = UIPageControl()
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  /// Список городов, сохраненных в БД
  private let list: [List]
  /// Индекс города, показанного на экране
  private var currentIndex: Int
  /// Массив контроллеров с городами из list с прогрнозами погоды
  private var cityPage = [MainWeatherViewController]()
  
  
  init(for list: [List], index: Int) {
    self.list = list
    self.currentIndex = index
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
    pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let pageFrame = CGRect(x: view.frame.width / 2 - pageControl.frame.width / 2, y: adapted(dimensionSize: 105, to: .height), width: pageControl.frame.width, height: adapted(dimensionSize: 8, to: .height))
    pageControl.frame = pageFrame
    
  }
  
  // MARK: - Private functions
  
  private func configurePageControl() {
    pageControl.numberOfPages = list.count
    pageControl.currentPage = currentIndex
    pageControl.tintColor = .green
    pageControl.pageIndicatorTintColor = .black
    pageControl.currentPageIndicatorTintColor = .white
    pageControl.hidesForSinglePage = true
    pageControl.backgroundStyle = .automatic
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pageControl)
  }
  
  @objc private func pageControlTapped(_ sender: UIPageControl) {
    setViewControllers([cityPage[sender.currentPage]], direction: .forward, animated: true, completion: nil)
  }
  
  private func setupPageController() {
    self.dataSource = self
    self.delegate = self
    
    
    list.forEach {
      let vc = MainWeatherViewController(for: $0)
      cityPage.append(vc)
    }
    setViewControllers([cityPage[currentIndex]], direction: .forward, animated: true, completion: nil)
  }
  
}

// MARK: - UIViewController delegates

extension CityListPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = cityPage.firstIndex(of: viewController as! MainWeatherViewController) else { return nil }
    if currentIndex == 0 {
      return cityPage.last
    } else {
      return self.cityPage[currentIndex - 1]
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = cityPage.firstIndex(of: viewController as! MainWeatherViewController) else { return nil }
    if currentIndex < cityPage.count - 1 {
      return cityPage[currentIndex + 1]
    } else {
      return cityPage.first
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


