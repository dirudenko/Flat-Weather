//
//  SettingsViewModel.swift
//  MyApp
//
//  Created by Dmitry on 20.01.2022.
//

import Foundation

protocol SettingsViewModelProtocol {
  var updateViewData: ((SettingsViewData) -> ())? { get set }
  func changeSettings(unit: Settings, type: UnitOptions)
  func unitPressed()
}

class SettingsViewModel: SettingsViewModelProtocol {
  
  // MARK: - Public variables
  var updateViewData: ((SettingsViewData) -> ())?
  // MARK: - Initialization
  init() {
    updateViewData?(.initial)
  }
  // MARK: - Public functions
  
  func unitPressed() {
    updateViewData?(.loading)
  }
  
  func changeSettings(unit: Settings, type: UnitOptions) {
    switch type {
    case .temperature:
      let temperature = unit as? Temperature
      UserDefaultsManager.set(temperature,forKey: "Temperature")
      UserDefaults.standard.set(true, forKey: "UnitChange")
    case .wind:
      let temperature = unit as? WindSpeed
      UserDefaultsManager.set(temperature,forKey: "Wind")
      UserDefaults.standard.set(true, forKey: "UnitChange")
    case .pressure:
      let temperature = unit as? Pressure
      UserDefaultsManager.set(temperature,forKey: "Pressure")
      UserDefaults.standard.set(true, forKey: "UnitChange")
    }
    updateViewData?(.success)
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
