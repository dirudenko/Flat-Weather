//
//  WeatherEndPoint.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

 enum WeatherApi {
    case getWeather(city: String)
}

extension WeatherApi: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.openweathermap.org") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getWeather(_):
          return "/data/2.5/weather"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getWeather(let city):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["q": city,
                                                      "appid": NetworkManager.weatherAPIKey,
                                                      "lang": "ru"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
