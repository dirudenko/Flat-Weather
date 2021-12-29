//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  
  private(set) var headerWeaherViewController: HeaderWeatherViewController
  private var headerWeatherViewHeightSmall: NSLayoutConstraint?
  private var headerWeatherViewHeightBig: NSLayoutConstraint?
  
  private var footerWeaherViewController: FooterViewController
  private let forcatsButton = Button()
  
  private var weeklyWeatherViewController: WeeklyViewController
  private var weeklyWeatherViewTopSmall: NSLayoutConstraint?
  private var weeklyWeatherViewTopBig: NSLayoutConstraint?
  
  private var fetchedCityList: List
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  private var isPressed = false
  
  init(for list: List) {
    self.fetchedCityList = list
    let id = Int(fetchedCityList.id)
//    print(id)
    headerWeaherViewController = HeaderWeatherViewController(cityId: id)
    footerWeaherViewController = FooterViewController(cityId: id)
    weeklyWeatherViewController = WeeklyViewController(cityId: id)
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
    view.addSubview(weeklyWeatherViewController.view)
    setupConstraints()
    
    let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
    let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))

    swipeGestureRecognizerDown.direction = .down
    swipeGestureRecognizerUp.direction = .up
    view.addGestureRecognizer(swipeGestureRecognizerDown)
    view.addGestureRecognizer(swipeGestureRecognizerUp)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    headerWeaherViewController.view.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    headerWeaherViewController.view.layer.masksToBounds = true
    
    
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
    weeklyWeatherViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      
      
      weeklyWeatherViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      weeklyWeatherViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      weeklyWeatherViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      headerWeaherViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      headerWeaherViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      headerWeaherViewController.view.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .width)),
      
      footerWeaherViewController.view.topAnchor.constraint(equalTo: headerWeaherViewController.view.bottomAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      footerWeaherViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      footerWeaherViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      footerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 140, to: .height))
    ])
    
    weeklyWeatherViewTopBig = weeklyWeatherViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor)
    weeklyWeatherViewTopBig?.isActive = true
    weeklyWeatherViewTopSmall = weeklyWeatherViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 587, to: .height))

    headerWeatherViewHeightBig = headerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 565, to: .height))
    headerWeatherViewHeightBig?.isActive = true
    headerWeatherViewHeightSmall = headerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .height))
    
  }
}


