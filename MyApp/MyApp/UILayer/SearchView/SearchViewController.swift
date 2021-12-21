//
//  SearchViewController.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class SearchViewController: UIViewController {
  
  private let searchView = SearchView()
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  
  // MARK: - UIViewController lifecycle methods
  override func loadView() {
    super.loadView()
    self.view = searchView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchView.searchBar.delegate = self
    searchView.searchBar.becomeFirstResponder()
    searchView.tableView.delegate = self
    searchView.tableView.dataSource = self
    searchView.backgroundColor = UIColor(named: "backgroundColor")
    fetchDataFromCoreData()
  }
  
  deinit {
    print("SearchVC deleted")
  }
  // MARK: - Private functions
  /// Получение данных из CoreData
  private func fetchDataFromCoreData() {
    if coreDataManager.entityIsEmpty() {
      decodeList { result in
        switch result {
        case .success(let list):
          DispatchQueue.main.async {
            
            for item in list {
              self.coreDataManager.configure(json: item)
            }
            self.coreDataManager.saveContext()
            self.coreDataManager.loadSavedData()
            self.searchView.animation.removeFromSuperview()
            self.searchView.searchBar.isHidden = false
          }
        case .failure(let error):
          print(error.rawValue)
        }
      }
    } else {
      self.coreDataManager.loadSavedData()
      self.searchView.animation.removeFromSuperview()
      self.searchView.searchBar.isHidden = false
    }
  }
  
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
// MARK: - UIViewController delegates
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return coreDataManager.fetchedResultsController.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = coreDataManager.fetchedResultsController.sections![section]
    return sectionInfo.numberOfObjects
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
    var content = cell.defaultContentConfiguration()
    content.text = "\(coreDataManager.fetchedResultsController.object(at: indexPath).name) \(coreDataManager.fetchedResultsController.object(at: indexPath).country)"
    cell.backgroundColor = UIColor(named: "backgroundColor")
    
    cell.contentConfiguration = content
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let city = coreDataManager.fetchedResultsController.object(at: indexPath)
  //  print(coreDataManager.fetchedResultsController.object(at: indexPath))
//    UserDefaults.standard.set(city.name, forKey: "city")
//    UserDefaults.standard.set(city.lat, forKey: "lat")
//    UserDefaults.standard.set(city.lon, forKey: "lon")
//    UserDefaults.standard.set(city.id, forKey: "id")
    UserDefaults.standard.appendList(id: city.id)

//    let vc  = MainWeatherViewController()
//    vc.modalPresentationStyle = .fullScreen
//
//      self.dismiss(animated: false)
//
//
//    navigationController?.pushViewController(vc, animated: true)
//    navigationController?.viewControllers.first?.remove()

   // navigationController?.viewControllers.first?.remove()
    navigationController?.dismiss(animated: false, completion: nil)
    let vc  = MainWeatherViewController(city: [Int(city.id)])
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: false)
    
  }
}


extension SearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchView.tableView.isHidden = true
    searchView.tableView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    /// Передеча текста в качестве предиката для фетчРеквеста
    coreDataManager.cityListPredicate = NSPredicate(format: "name CONTAINS %@", searchText)
    coreDataManager.loadSavedData()
    print(coreDataManager.fetchedResultsController.fetchedObjects?.count)
    searchView.tableView.isHidden = false
    searchView.tableView.reloadData()
  }
}