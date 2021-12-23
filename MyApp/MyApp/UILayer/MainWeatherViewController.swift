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
  //  print(fetchedCityList.count)
    if  !fetchedCityList.isEmpty {
      let id = fetchedCityList.first?.id ?? 0
      coreDataManager.cityListPredicate = NSPredicate(format: "id == %i", id)
      coreDataManager.loadSavedData()
      guard let city = coreDataManager.fetchedResultsController.fetchedObjects?.first else { return }
      headerWeaherViewController = HeaderWeaherViewController(cityId: Int(city.id))
      footerWeaherViewController = FooterViewController(lat: city.lon, lon: city.lon)
      add(headerWeaherViewController!)
      add(footerWeaherViewController!)
      headerWeaherViewController?.weatherView.delegate = self      
    }
    else {
      searchViewController = SearchViewController()
      add(searchViewController!)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let headerFrame = CGRect(x: adapted(dimensionSize: 16, to: .width), y: adapted(dimensionSize: 62, to: .height), width: adapted(dimensionSize: 358, to: .width), height: adapted(dimensionSize: 565, to: .height))
        headerWeaherViewController?.view.frame = headerFrame
    headerWeaherViewController?.view.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
        headerWeaherViewController?.view.layer.masksToBounds = true
    
    let footerFrame = CGRect(x: 0, y: headerFrame.height + adapted(dimensionSize: 78, to: .height), width: view.frame.width, height: adapted(dimensionSize: 140, to: .height))
     footerWeaherViewController?.view.frame = footerFrame
    
    let searchFrame = CGRect(x: adapted(dimensionSize: 16, to: .width), y: adapted(dimensionSize: 62, to: .height), width: adapted(dimensionSize: 358, to: .width), height: adapted(dimensionSize: 766, to: .height))
    searchViewController?.view.frame = searchFrame
    searchViewController?.view.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    searchViewController?.view.layer.masksToBounds = true
  }
}




extension MainWeatherViewController: HeaderButtonsProtocol {
  func plusButtonTapped() {
//    let vc  = SearchViewController()
//    vc.modalPresentationStyle = .fullScreen
//    //present(vc, animated: false)
//    navigationController?.pushViewController(vc, animated: true)
    
    headerWeaherViewController?.remove()
    footerWeaherViewController?.remove()
    searchViewController = SearchViewController()
    add(searchViewController!)
  }
  
  
}
