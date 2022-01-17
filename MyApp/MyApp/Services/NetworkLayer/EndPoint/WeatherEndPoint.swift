//
//  WeatherEndPoint.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

enum WeatherApi {
  case getCurrentWeather(lon: Double, lat: Double)
  case getCityName(name: String)
 // case getWeeklyWeather(lon: Double, lat: Double)
}

extension WeatherApi: EndPointType {
  
  var baseURL: URL {
    guard let url = URL(string: "https://api.openweathermap.org") else { fatalError("baseURL could not be configured.")}
    return url
  }
  
  var path: String {
    switch self {
    case .getCurrentWeather(_,_):
      return "/data/2.5/onecall"
    case .getCityName(_):
      return "/geo/1.0/direct"
//    case .getWeeklyWeather(_,_):
//      return "/data/2.5/onecall"
    }
  }
  
  
  var httpMethod: HTTPMethod {
    return .get
  }
  
  var task: HTTPTask {
    switch self {
    case .getCurrentWeather(let lon, let lat):
      return .requestParameters(bodyParameters: nil,
                                bodyEncoding: .urlEncoding,
                                urlParameters: [
                                  "lat": lat,
                                  "lon": lon,
                                  "exclude": "minutely,alerts",
                                  "appid": NetworkManager.weatherAPIKey,
                                  "units": "metric",
                                  "lang": "en",
                                ])
    case .getCityName(let name):
      return .requestParameters(bodyParameters: nil,
                                bodyEncoding: .urlEncoding,
                                urlParameters: [
                                  "q": name,
                                  "limit": 5,
                                  "appid": NetworkManager.weatherAPIKey
                                ])
   //                                            ])
//    case .getHourlyWeather(let lon, let lat):
//      return .requestParameters(bodyParameters: nil,
//                                bodyEncoding: .urlEncoding,
//                                urlParameters: [
//                                  "lat": lat,
//                                  "lon": lon,
//                                  "exclude": "current,minutely,daily,alerts",
//                                  "appid": NetworkManager.weatherAPIKey,
//                                  "units": "metric",
//                                  "lang": "ru",
//                                ])
//    case .getWeeklyWeather(let lon, let lat):
//      return .requestParameters(bodyParameters: nil,
//                                bodyEncoding: .urlEncoding,
//                                urlParameters: [
//                                  "lat": lat,
//                                  "lon": lon,
//                                  "exclude": "minutely,alerts",
//                                  "appid": NetworkManager.weatherAPIKey,
//                                  "units": "metric",
//                                  "lang": "ru",
//                                ])
    }
  }
  
  var headers: HTTPHeaders? {
    return nil
  }
}
