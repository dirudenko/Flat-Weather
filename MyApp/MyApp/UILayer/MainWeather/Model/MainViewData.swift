//
//  ViewData.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation
/// Состояния для Data Driven UI
enum MainViewData {
  case initial
  case fetching(MainInfo)
  case loading
  case success(MainInfo)
  case failure
  
}
