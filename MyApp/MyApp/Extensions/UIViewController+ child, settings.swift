//
//  UIVC+ child.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

extension UIViewController {
  func add(_ child: UIViewController) {
    addChild(child)
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }
  func remove() {
    guard parent != nil else {
      return
    }
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
  func checkSettings() {
    let temperature: String? = UserDefaultsManager.get(forKey: "Temperature")
    let wind: String? = UserDefaultsManager.get(forKey: "Wind")
    let pressure: String? = UserDefaultsManager.get(forKey: "Atmospheric")
    
    if temperature == nil {
      let temperature: Temperature = .Celcius
      UserDefaultsManager.set(temperature.description,forKey: "Temperature")
    }
    
    
    if wind == nil {
      let wind: WindSpeed = .kmh
      UserDefaultsManager.set(wind.description,forKey: "Wind")
    }
    
    if pressure == nil {
      let pressure: Pressure = .mbar
      UserDefaultsManager.set(pressure.description,forKey: "Atmospheric")
    }
  }
}

