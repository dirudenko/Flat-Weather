//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  
  private let headerWeaherViewController = HeaderWeaherViewController()
  private let footerWeaherViewController = FooterViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    add(headerWeaherViewController)
    add(footerWeaherViewController)
    view.backgroundColor = .systemBackground
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let headerFrame = CGRect(x: 16, y: 62, width: 358, height: 565)
    headerWeaherViewController.view.frame = headerFrame
    headerWeaherViewController.view.layer.cornerRadius = 30
    headerWeaherViewController.view.layer.masksToBounds = true
    
    let footerFrame = CGRect(x: 0, y: 643, width: 390, height: 140)
    footerWeaherViewController.view.frame = footerFrame
    
  }
}
