//
//  NetworkManager.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

protocol NetworkManagerProtocol {
  func getWeather(lon: Double, lat: Double, completion: @escaping (Result<WeatherModel, NetworkErrors>) -> Void)
  func getCityName(name: String, completion: @escaping (Result<[SearchModel], NetworkErrors>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
  
  var router = Router<WeatherApi>()
  
  func getWeather(lon: Double, lat: Double, completion: @escaping (Result<WeatherModel, NetworkErrors>) -> Void) {
    router.request(.getCurrentWeather(lon: lon, lat: lat)) { data, response, error in
      
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
            //let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
            //print(jsonData)
            let apiResponse = try JSONDecoder().decode(WeatherModel.self, from: responseData)
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
  
  func getCityName(name: String, completion: @escaping (Result<[SearchModel], NetworkErrors>) -> Void) {
    router.request(.getCityName(name: name)) { data, response, error in
      
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
            //let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
            //print(jsonData)
            let apiResponse = try JSONDecoder().decode([SearchModel].self, from: responseData)
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
  
  private func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseErrors<NetworkErrors>{
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure(NetworkErrors.authenticationError)
    case 501...599: return .failure(NetworkErrors.badRequest)
    case 600: return .failure(NetworkErrors.outdated)
    default: return .failure(NetworkErrors.failed)
    }
  }
}


class MockNetworkManager: NetworkManagerProtocol {
  
  var router: Router<WeatherApi>?
  var getWeatherResult: Result<WeatherModel, NetworkErrors>?
  var getSearchResult: Result<[SearchModel], NetworkErrors>?
  var weatherExecudeCalled = false
  var searchExecuteCalled = false
  
  func getWeather(lon: Double, lat: Double, completion: @escaping (Result<WeatherModel, NetworkErrors>) -> Void) {
    weatherExecudeCalled = true
    router = Router<WeatherApi>()
    getWeatherResult.map(completion)
  }
  
  func getCityName(name: String, completion: @escaping (Result<[SearchModel], NetworkErrors>) -> Void) {
    searchExecuteCalled = true
    router = Router<WeatherApi>()
    getSearchResult.map(completion)
  }
  
  
}

struct FakeNetworkService {
 
  let networkManager: NetworkManagerProtocol
  func search(_ name: String, completion: @escaping (Result<[SearchModel], Error>) -> Void) {
    networkManager.getCityName(name: name) { result in
    //  completion(self.parse(result))
    }
  }
        
        private func parse(_ result: Result<Data, Error>) -> Result<SearchModel, Error> {
                switch result {
                case let .success(data):
                    return Result { try JSONDecoder().decode(SearchModel.self, from: data) }

                case let .failure(error):
                    return .failure(error)
                }
            }
  
  
}
