//
//  NetworkManager.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

struct NetworkManager {
  
  static let weatherAPIKey = "4151621f5318e81115ce7581adb25359"
  let router = Router<WeatherApi>()
  
  func getWeather(city: String, completion: @escaping (Result<CurrentWeather, NetworkErrors>) -> Void) {
    router.request(.getCurrentWeather(city: city)) { data, response, error in
      
      if let _ = error {
        completion(.failure(.badRequest))
        return
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(.failure(.noData))
            return
          }
          do {
            print(responseData)
            //let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
            //print(jsonData)
            let apiResponse = try JSONDecoder().decode(CurrentWeather.self, from: responseData)
            completion(.success(apiResponse))
          } catch {
            print(error)
            completion(.failure(.unableToDecode))
          }
        case .failure(let networkFailureError):
          completion(.failure(networkFailureError))
        }
      }
    }
  }
      
      func getHourlyWeather(lon: Double, lat: Double, completion: @escaping (Result<HourlyWeather, NetworkErrors>) -> Void) {
        router.request(.getHourlyWeather(lon: lon, lat: lat)) { data, response, error in
          
          if let _ = error {
            completion(.failure(.badRequest))
            return
          }
          
          if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
              guard let responseData = data else {
                completion(.failure(.noData))
                return
              }
              do {
               // print(responseData)
               // let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
               // print(jsonData)
                let apiResponse = try JSONDecoder().decode(HourlyWeather.self, from: responseData)
                completion(.success(apiResponse))
              } catch {
                print(error)
                completion(.failure(.unableToDecode))
              }
            case .failure(let networkFailureError):
              completion(.failure(networkFailureError))
            }
          }
        }
      
      
    }

  
  
  fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseErrors<NetworkErrors>{
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure(NetworkErrors.authenticationError)
    case 501...599: return .failure(NetworkErrors.badRequest)
    case 600: return .failure(NetworkErrors.outdated)
    default: return .failure(NetworkErrors.failed)
    }
  }
}
