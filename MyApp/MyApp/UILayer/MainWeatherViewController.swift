//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  
  private var headerWeaherViewController: HeaderWeaherViewController
  private var headerWeaherViewHeightSmall: NSLayoutConstraint?
  private var headerWeaherViewHeightBig: NSLayoutConstraint?
  
  private var footerWeaherViewController: FooterViewController
  private var searchViewController: SearchViewController?
  private var fetchedCityList: List
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  private var isPressed = false
  
  init(for list: List) {
    self.fetchedCityList = list
    let id = Int(fetchedCityList.id)
    headerWeaherViewController = HeaderWeaherViewController(cityId: id)
    footerWeaherViewController = FooterViewController(cityId: id)
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
    headerWeaherViewController.weatherView.delegate = self
    setupConstraints()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    headerWeaherViewController.view.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    headerWeaherViewController.view.layer.masksToBounds = true
    
    let searchFrame = CGRect(x: adapted(dimensionSize: 16, to: .width), y: adapted(dimensionSize: 62, to: .height), width: adapted(dimensionSize: 358, to: .width), height: adapted(dimensionSize: 766, to: .height))
    searchViewController?.view.frame = searchFrame
    searchViewController?.view.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    searchViewController?.view.layer.masksToBounds = true
  }
}




extension MainWeatherViewController: HeaderButtonsProtocol {
  func plusButtonTapped() {
    isPressed = !isPressed
    headerWeaherViewController.weatherView.changeConstraints(isPressed: isPressed)
    if isPressed {
      headerWeaherViewHeightBig?.isActive = false
      headerWeaherViewHeightSmall?.isActive = true
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    } else {
      headerWeaherViewHeightSmall?.isActive = false
      headerWeaherViewHeightBig?.isActive = true
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    }
    
  }
}
//    headerWeaherViewController?.remove()
//    footerWeaherViewController?.remove()
//    searchViewController = SearchViewController()
//    add(searchViewController!)
// }

extension MainWeatherViewController {
  private func setupConstraints() {
    headerWeaherViewController.view.translatesAutoresizingMaskIntoConstraints = false
    footerWeaherViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      headerWeaherViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      headerWeaherViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      headerWeaherViewController.view.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .width)),
      
      footerWeaherViewController.view.topAnchor.constraint(equalTo: headerWeaherViewController.view.bottomAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      footerWeaherViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      footerWeaherViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      footerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 140, to: .height))
    ])
    headerWeaherViewHeightBig = headerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 565, to: .height))
    headerWeaherViewHeightBig?.isActive = true
    headerWeaherViewHeightSmall = headerWeaherViewController.view.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .height))
    
  }
}


