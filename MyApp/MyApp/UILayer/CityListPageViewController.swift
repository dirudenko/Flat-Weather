//
//  CityListPageViewController.swift
//  MyApp
//
//  Created by Dmitry on 24.12.2021.
//

import UIKit

class CityListPageViewController: UIPageViewController {
  
  var viewController: [MainWeatherViewController] = []
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  let list: [List]
  private var currentIndex = 0
  
  init(for list: [List], index: Int) {
    self.list = list
    self.currentIndex = index
    //viewController = MainWeatherViewController(for: list, index: index)
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .systemBackground
      setupPageController()
      for item in 0 ... list.count {
        print(list.count)
        let vc = MainWeatherViewController(for: list, index: item)
        viewController.append(vc)
        print(viewController.count)
      }
      let initialVC = MainWeatherViewController(for: list, index: currentIndex)
      setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)

    }
  
  private func setupPageController() {
  //self = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  self.dataSource = self
  self.delegate = self
  self.view.backgroundColor = .clear
  self.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
  }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }


}

extension CityListPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    guard let currentVC = viewController as? MainWeatherViewController else {
               return nil
           }
           
    var index = currentVC.index
           
           if index == 0 {
               return nil
           }
           
           index -= 1
           
           let vc: MainWeatherViewController = MainWeatherViewController(for: list, index: index)
           
           return self.viewController[index]
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentVC = viewController as? MainWeatherViewController else {
                return nil
            }
            
            var index = currentVC.index
            
            if index >= self.list.count - 1 {
                return nil
            }
            
            index += 1
            
    
            
    return self.viewController[index]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
  return list.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
  return self.currentIndex
  }
}
