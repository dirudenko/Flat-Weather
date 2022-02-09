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
  /// Проверка наличия размерности данных и их установка в случае необходимости
  func checkSettings() {
    let temperature: Temperature? = UserDefaultsManager.get(forKey: "Temperature")
   // let wind: WindSpeed? = UserDefaultsManager.get(forKey: "Wind")
    let pressure: Pressure? = UserDefaultsManager.get(forKey: "Pressure")

    if temperature == nil {
      let temperature: Temperature = .celcius
      UserDefaultsManager.set(temperature, forKey: "Temperature")
    }

    switch temperature {
    case .fahrenheit:
      let wind: WindSpeed = .milh
      UserDefaultsManager.set(wind, forKey: "Wind")
    default:
      let wind: WindSpeed = .ms
      UserDefaultsManager.set(wind, forKey: "Wind")
    }

    if pressure == nil {
      let pressure: Pressure = .hPa
      UserDefaultsManager.set(pressure, forKey: "Pressure")
    }
  }
}
