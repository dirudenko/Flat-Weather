//
//  NetworkService.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

//final class NetworkService {
//  
//  let constanse = NetworkConstants()
//  
//  let configuration = URLSessionConfiguration.default
//  
//  func getWeaherByCityName(city: String, complition: @escaping (Result<CityWeather, NetworkErrors>) -> Void) {
//    let session = URLSession(configuration: configuration)
//    
//    var components = URLComponents()
//    
//    components.scheme = constanse.scheme
//    components.host = constanse.host
//    components.path =  "/data/2.5/weather"
//    components.queryItems = [
//                URLQueryItem(name: "q", value: city),
//                URLQueryItem(name: "appid", value: "4151621f5318e81115ce7581adb25359")
//            ]
//
//    
//    guard let url = components.url else { return }
//    let request = URLRequest(url: url)
//    let task = session.dataTask(with: request) { data, response, error in
//      
//      if let _ = error {
//        complition(.failure(.unableToComplete))
//        return
//      }
//      
//      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//        complition(.failure(.invalidResponse))
//        return
//      }
//      
//      guard let data = data else {
//        complition(.failure(.invalidData))
//        return
//      }
//      
//      do {
//        let decoder = JSONDecoder()
//        let weather = try decoder.decode(CityWeather.self, from: data)
//        DispatchQueue.main.async {
//         // print(data.prettyJSON)
//
//          complition(.success(weather))
//        }
//      } catch {
//        complition(.failure(.invalidModel))
//      }
//    }
//    task.resume()
//  }
//}
//
//
//
//
//
//struct NetworkConstants {
//  
//  let scheme = "https"
//  
//  let host = "api.openweathermap.org"
//  
//
//}


