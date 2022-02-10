//
//  UIVC+ child.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

extension UIViewController {
  /// добавление и удаление subview
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
  /// вывод сообщения об ошибке
  func showSystemAlert(text: String) {
    let alert = UIAlertController(title: "My Title", message: text, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  /// Проверка наличия размерности данных и их установка в случае необходимости
  func checkSettings() {
    let temperature: Temperature? = UserDefaultsManager.get(forKey: "Temperature")
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
