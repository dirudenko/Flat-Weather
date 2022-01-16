//
//  SearchViewModel.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

protocol SearchViewModelProtocol {
  var updateViewData: ((SearchViewData) ->())? { get set }
  var networkManager: NetworkManagerProtocol { get }
  var coreDataManager: CoreDataManagerResultProtocol { get }
  func startFetch()
}

final class SearchViewModel: SearchViewModelProtocol {
  // MARK: - Public variables
  var networkManager: NetworkManagerProtocol
  var updateViewData: ((SearchViewData) -> ())?
  var coreDataManager: CoreDataManagerResultProtocol
 
  // MARK: - Initialization
  init(networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerResultProtocol) {
    updateViewData?(.initial)
    self.coreDataManager = coreDataManager
    self.networkManager = networkManager
  }
  // MARK: - Public functions
  func startFetch() {
    if coreDataManager.entityIsEmpty() {
      decodeList { result in
        switch result {
        case .success(let list):
          DispatchQueue.main.async {
            
            for item in list {
              self.coreDataManager.configure(json: item)
            }
            self.coreDataManager.saveContext()
            self.coreDataManager.loadListData()
            self.updateViewData?(.success)
          }
        case .failure(let error):
          print(error.rawValue)
          DispatchQueue.main.async {
            self.updateViewData?(.failure)
          }
        }
      }
    } else {
      DispatchQueue.main.async {
        self.coreDataManager.loadListData()
        self.updateViewData?(.success)
      }
      
    }
  }
  // MARK: - Private functions
  /// Декодирование JSON файла с городами из Ассетов
  private func decodeList(complition: @escaping (Result<[CitiList], NetworkError>) -> Void) {
    let decoder = JSONDecoder()
    guard let fileURL = Bundle.main.url(forResource:"city.list", withExtension: "json"),
          let fileContents = try? String(contentsOf: fileURL) else { return }
    let data = Data(fileContents.utf8)
    do {
      let list = try decoder.decode([CitiList].self, from: data)
      complition(.success(list))
    } catch {
      complition(.failure(.encodingFailed))
    }
  }
}
