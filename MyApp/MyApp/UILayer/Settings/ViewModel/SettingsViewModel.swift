//
//  SettingsViewModel.swift
//  MyApp
//
//  Created by Dmitry on 20.01.2022.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
  var updateViewData: ((SettingsViewData) -> ())? { get set }
  func getSettings() -> SettingsModel?
  func changeSettings(unit: Settings, type: UnitOptions)
  func unitPressed()
}

class SettingsViewModel: SettingsViewModelProtocol, SubcribeSettings {
  func settingsChanged(unit: Settings, type: UnitOptions) {
    changeSettings(unit: unit, type: type)
  }
  
  
  
  // MARK: - Public variables
  var updateViewData: ((SettingsViewData) -> ())?
  var observer: SettingsObserver
  // MARK: - Initialization
  init(observer: SettingsObserver) {
    updateViewData?(.initial)
    self.observer = observer
    self.observer.register(observer: self)
  }
  // MARK: - Public functions
  
//  func model() -> SettingsModel {
//    guard let model = getSettings() else { fatalError() }
//    return model
//  }
  
  func unitPressed() {
    updateViewData?(.loading)
  }
  
  func changeSettings(unit: Settings, type: UnitOptions) {
    switch type {
    case .temperature:
      let temperature = unit as? Temperature
      if temperature != UserDefaultsManager.get(forKey: "Temperature") {
      UserDefaultsManager.set(temperature,forKey: "Temperature")
        observer.notifyObserver(unit: unit, type: type)
      } else {
        updateViewData?(.success)
      }
    case .wind:
      let wind = unit as? WindSpeed
     // UserDefaultsManager.set(temperature,forKey: "Wind")
      if wind != UserDefaultsManager.get(forKey: "Wind") {
      UserDefaultsManager.set(wind,forKey: "Wind")
        observer.notifyObserver(unit: unit, type: type)
      } else {
        updateViewData?(.success)
      }    case .pressure:
      let pressure = unit as? Pressure
     // UserDefaultsManager.set(temperature,forKey: "Pressure")
      if pressure != UserDefaultsManager.get(forKey: "Pressure") {
      UserDefaultsManager.set(pressure,forKey: "Pressure")
        observer.notifyObserver(unit: unit, type: type)
      } else {
        updateViewData?(.success)
      }    }
   // updateViewData?(.success)
  }
  // MARK: - Private functions
  func getSettings() -> SettingsModel? {
    guard let temperature: Temperature = UserDefaultsManager.get(forKey: "Temperature"),
    let wind: WindSpeed = UserDefaultsManager.get(forKey: "Wind"),
            let pressure: Pressure = UserDefaultsManager.get(forKey: "Pressure") else { return nil }
    let model = SettingsModel (temperature: temperature,
                               wind: wind,
                               pressure: pressure)
    
    return model
  }
}
