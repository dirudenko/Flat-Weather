//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  
  private var headerWeaherViewController: HeaderWeaherViewController?
  private var footerWeaherViewController: FooterViewController?
  private var searchViewController: SearchViewController?
  private var fetchedCityList: [List]
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  
  
  
  
  init(for list: [List]) {
    self.fetchedCityList = list
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  // TODO: - брать данные из List
    if  !fetchedCityList.isEmpty {
      let id = fetchedCityList.first?.id ?? 0
      coreDataManager.cityListPredicate = NSPredicate(format: "id == %i", id)
      coreDataManager.loadSavedData()
      guard let city = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return }
      headerWeaherViewController = HeaderWeaherViewController(cityId: Int(city.id))
      footerWeaherViewController = FooterViewController(lat: city.lon, lon: city.lon)
      add(headerWeaherViewController!)
      add(footerWeaherViewController!)
    //  setupButtonConstraints()
      
    }
    else {
      searchViewController = SearchViewController()
      add(searchViewController!)
    }
  }
  
  var heightConstraint = NSLayoutConstraint()
  var widthConstraint  = NSLayoutConstraint()
  var topConstraint    = NSLayoutConstraint()
  var centerConstraint = NSLayoutConstraint()
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
   // updateConstraints()
    let headerFrame = CGRect(x: adapted(dimensionSize: 16, to: .width), y: topSpace, width: adapted(dimensionSize: 358, to: .width), height: adapted(dimensionSize: 565, to: .height))
        headerWeaherViewController?.view.frame = headerFrame
        headerWeaherViewController?.view.layer.cornerRadius = 30
        headerWeaherViewController?.view.layer.masksToBounds = true
    
    let footerFrame = CGRect(x: 0, y: headerFrame.height + adapted(dimensionSize: 78, to: .height), width: view.frame.width, height: footerSize.height)
     footerWeaherViewController?.view.frame = footerFrame
    
    let searchFrame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
    searchViewController?.view.frame = searchFrame
  }
}


extension MainWeatherViewController {
  func updateConstraints() {
    updateButtonConstraints()
   // view.updateAdaptedConstraints()
  }
  
  var headerSize: CGSize {
    resized(size: CGSize(width: 358, height: 565), basedOn: .height)
  }
  
  var footerSize: CGSize {
    resized(size: CGSize(width: 390, height: 140), basedOn: .height)
  }
  
  var topSpace: CGFloat {
    adapted(dimensionSize: 62, to: .height)
  }
  
  func setupButtonConstraints() {
    widthConstraint  = headerWeaherViewController!.view.widthAnchor.constraint(equalToConstant: headerSize.width)
    heightConstraint = headerWeaherViewController!.view.heightAnchor.constraint(equalToConstant: headerSize.height)
    topConstraint    = headerWeaherViewController!.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace)
    centerConstraint = headerWeaherViewController!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    
    NSLayoutConstraint.activate([
      widthConstraint,
      heightConstraint,
      topConstraint,
      centerConstraint
    ])
  }
  
  func updateButtonConstraints() {
    topConstraint.constant    = topSpace
    widthConstraint.constant  = headerSize.width
    heightConstraint.constant = headerSize.height
  }
}
