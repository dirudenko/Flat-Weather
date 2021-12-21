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

    if  !fetchedCityList.isEmpty {
      let id = fetchedCityList.first?.id ?? 0
      coreDataManager.cityListPredicate = NSPredicate(format: "id == %i", id)
      coreDataManager.loadSavedData()
      guard let city = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return }
      headerWeaherViewController = HeaderWeaherViewController(cityId: Int(id))
      footerWeaherViewController = FooterViewController(lat: city.lat, lon: city.lon)
      add(headerWeaherViewController!)
      add(footerWeaherViewController!)
    }
    else {
      searchViewController = SearchViewController()
            add(searchViewController!)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let headerFrame = CGRect(x: 16, y: 62, width: view.frame.width - 32, height: 565)
    headerWeaherViewController?.view.frame = headerFrame
    headerWeaherViewController?.view.layer.cornerRadius = 30
    headerWeaherViewController?.view.layer.masksToBounds = true
    
    let footerFrame = CGRect(x: 0, y: headerFrame.height + 78, width: view.frame.width, height: 140)
    footerWeaherViewController?.view.frame = footerFrame
    
    let searchFrame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
    searchViewController?.view.frame = searchFrame
  }
}
