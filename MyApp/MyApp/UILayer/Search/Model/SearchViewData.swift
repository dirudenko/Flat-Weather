//
//  SearchViewData.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

enum SearchViewData {
  case initial
  case load
  case success([SearchModel])
  case failure(String)
}
