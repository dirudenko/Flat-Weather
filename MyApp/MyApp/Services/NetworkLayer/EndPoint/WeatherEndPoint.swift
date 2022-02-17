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
}

enum Units: String {
  case metric
  case imperial
}

extension WeatherApi: EndPointType {

  var baseURL: URL {
    guard let url = URL(string: "https://api.openweathermap.org") else { fatalError("baseURL could not be configured.")}
    return url
  }

  var path: String {
    switch self {
    case .getCurrentWeather:
      return "/data/2.5/onecall"
    case .getCityName:
      return "/geo/1.0/direct"
    }
  }

  var units: Units {
    let temperature: Temperature? = UserDefaultsManager.get(forKey: "Temperature")
    switch temperature {
    case .celcius:
      return .metric
    case .fahrenheit:
      return .imperial
    default: fatalError()
    }
  }

  var httpMethod: HTTPMethod {
    return .get
  }

  var task: HTTPTask {
    switch self {
    case .getCurrentWeather(let lon, let lat):
      let searchLanguage = NSLocalizedString("apiCallLanguage", comment: "search Language")

      return .requestParameters(bodyParameters: nil,
                                bodyEncoding: .urlEncoding,
                                urlParameters: [
                                  "lat": lat,
                                  "lon": lon,
                                  "exclude": "minutely,alerts",
                                  "appid": Constants.Network.weatherAPIKey,
                                  "units": units.rawValue,
                                  "lang": searchLanguage
                                ])
    case .getCityName(let name):
      return .requestParameters(bodyParameters: nil,
                                bodyEncoding: .urlEncoding,
                                urlParameters: [
                                  "q": name,
                                  "limit": 20,
                                  "appid": Constants.Network.weatherAPIKey
                                ])
    }
  }

  var headers: HTTPHeaders? {
    return nil
  }
}
