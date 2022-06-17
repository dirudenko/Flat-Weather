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
  
  private var apiKey: String {
      guard let filePath = Bundle.main.path(forResource: "OpenWeather-Info", ofType: "plist") else {
        fatalError("Couldn't find file 'OpenWeather-Info.plist'.")
      }
      let plist = NSDictionary(contentsOfFile: filePath)
      guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'OpenWeather-Info.plist'.")
      }
    
     if (value.starts(with: "_")) {
          fatalError("Register for a OpenWeather developer account and get an API key")
        }
      return value
  }

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
                                  "appid": apiKey,
                                  "units": units.rawValue,
                                  "lang": searchLanguage
                                ])
    case .getCityName(let name):
      return .requestParameters(bodyParameters: nil,
                                bodyEncoding: .urlEncoding,
                                urlParameters: [
                                  "q": name,
                                  "limit": 20,
                                  "appid": apiKey
                                ])
    }
  }

  var headers: HTTPHeaders? {
    return nil
  }
}
