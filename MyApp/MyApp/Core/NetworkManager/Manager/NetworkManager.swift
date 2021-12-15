//
//  NetworkManager.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

enum NetworkResponse: String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum ResultResponse<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let weatherAPIKey = "4151621f5318e81115ce7581adb25359"
    let router = Router<WeatherApi>()
    
  func getWeaher(city: String, completion: @escaping (Result<CityWeather, NetworkResponse>) -> Void){
        router.request(.getWeather(city: city)) { data, response, error in
            
          if let _ = error {
            completion(.failure(.failed))
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
                        let apiResponse = try JSONDecoder().decode(CityWeather.self, from: responseData)
                      completion(.success(apiResponse))
                    } catch {
                        print(error)
                      completion(.failure(.unableToDecode))
                    }
                case .failure(let networkFailureError):
                  print(networkFailureError)
                  completion(.failure(.noData))
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> ResultResponse<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
