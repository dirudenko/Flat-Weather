//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class MainWeatherViewController: UIViewController {

  let headerWeaherViewController = HeaderWeaherViewController()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        add(headerWeaherViewController)
      view.backgroundColor = .systemBackground
    }
    
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let frame = CGRect(x: 16, y: 62, width: 358, height: 565)
    headerWeaherViewController.view.frame = frame
    headerWeaherViewController.view.layer.cornerRadius = 30
    headerWeaherViewController.view.layer.masksToBounds = true

  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
