//
//  TestEndPoints.swift
//  MyApp
//
//  Created by Dmitry on 06.02.2022.
//

import Foundation

enum TestApi {
  case getCurrentWeather(lon: Double, lat: Double)
  case getCityName(name: String)
}



extension TestApi: EndPointType {
  
  var baseURL: URL {
    guard let url = URL(string: "Test") else { fatalError("baseURL could not be configured.")}
    return url
  }
  
  var path: String {
    switch self {
    case .getCurrentWeather(_,_):
      return "Test"
    case .getCityName(let name):
      return name
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
  
  var task: HTTPTask {
    switch self {
    case .getCurrentWeather(_, _):
      return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
    case .getCityName(_):
      return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
    }
  }
  
  var headers: HTTPHeaders? {
    return nil
  }
}
