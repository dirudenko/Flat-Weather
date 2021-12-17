//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  
//  private let headerWeaherViewController = HeaderWeaherViewController()
//  private let footerWeaherViewController = FooterViewController()
  private let searchViewController = SearchViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //add(headerWeaherViewController)
   // add(footerWeaherViewController)
    add(searchViewController)
    view.backgroundColor = .systemBackground
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let safeArea = self.view.safeAreaLayoutGuide

//    let headerFrame = CGRect(x: 16, y: 62, width: 358, height: 565)
//    headerWeaherViewController.view.frame = headerFrame
//    headerWeaherViewController.view.layer.cornerRadius = 30
//    headerWeaherViewController.view.layer.masksToBounds = true
//
//    let footerFrame = CGRect(x: 0, y: 643, width: 390, height: 140)
//    footerWeaherViewController.view.frame = footerFrame
    
    let searchFrame = CGRect(x: safeArea.layoutFrame.minX, y: safeArea.layoutFrame.minY, width: safeArea.layoutFrame.width, height: safeArea.layoutFrame.height)
    searchViewController.view.frame = searchFrame
  }
}
