//
//  ViewData.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

enum ViewData {
  case initial
  case loading(MainInfo)
  case success(WeatherModel?, MainInfo?)
  case failure
  
}
