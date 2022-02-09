//
//  SettingsViewModel.swift
//  MyApp
//
//  Created by Dmitry on 20.01.2022.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
  var updateViewData: ((SettingsViewData) -> Void)? { get set }
  func changeSettings(unit: Settings, type: UnitOptions)
  func unitPressed()
}

class SettingsViewModel: SettingsViewModelProtocol {
  // MARK: - Public variables
  var updateViewData: ((SettingsViewData) -> Void)?
  var observer: SettingsObserver
  // MARK: - Initialization
  init(observer: SettingsObserver) {
    updateViewData?(.initial)
    self.observer = observer
    self.observer.register(observer: self)
  }
  // MARK: - Public functions
  /// вывод на экран PickerView при нажатии на размерность
  func unitPressed() {
    updateViewData?(.loading)
  }
  /// изменение типа размерности
  func changeSettings(unit: Settings, type: UnitOptions) {
    switch type {
    case .temperature:
      let temperature = unit as? Temperature
      if temperature != UserDefaultsManager.get(forKey: "Temperature") {
      UserDefaultsManager.set(temperature, forKey: "Temperature")
        observer.notifyObserver(unit: unit, type: type)
      } else {
        updateViewData?(.success)
      }
    case .wind:
      let wind = unit as? WindSpeed
      if wind != UserDefaultsManager.get(forKey: "Wind") {
      UserDefaultsManager.set(wind, forKey: "Wind")
        observer.notifyObserver(unit: unit, type: type)
      } else {
        updateViewData?(.success)
      }
    case .pressure:
      let pressure = unit as? Pressure
      if pressure != UserDefaultsManager.get(forKey: "Pressure") {
      UserDefaultsManager.set(pressure, forKey: "Pressure")
        observer.notifyObserver(unit: unit, type: type)
      } else {
        updateViewData?(.success)
      }    }
  }
}
// MARK: - Observer 
extension SettingsViewModel: SubcribeSettings {
  func settingsChanged(unit: Settings, type: UnitOptions) {
    DispatchQueue.main.async {
      self.changeSettings(unit: unit, type: type)

    }
  }
}
