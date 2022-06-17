//
//  SettingsObserver.swift
//  MyApp
//
//  Created by Dmitry on 24.01.2022.
//

import Foundation

protocol SubcribeSettings: AnyObject {
  func settingsChanged(unit: Settings, type: UnitOptions)
}

class SettingsObserver {

  var observers = [SubcribeSettings]()

  func receiveType (unit: Settings, type: UnitOptions) {
    notifyObserver(unit: unit, type: type)
  }

  func register(observer: SubcribeSettings) {
    observers.append(observer)
  }

  func notifyObserver(unit: Settings, type: UnitOptions) {
    for observer in observers {
      observer.settingsChanged(unit: unit, type: type)
    }
  }

  func deregister() {
    observers.removeAll()
  }
}
