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
    searchView.searchTableView.delegate = self
    searchView.searchTableView.dataSource = self
    searchView.cityListTableView.delegate = self
    searchView.cityListTableView.dataSource = self
    searchView.backgroundColor = UIColor(named: "backgroundColor")
    fetchDataFromCoreData()
    //view.backgroundColor = .systembac
  }
  
  deinit {
    print("SearchVC deleted")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let searchFrame = CGRect(x: adapted(dimensionSize: 16, to: .width), y: adapted(dimensionSize: 62, to: .height), width: adapted(dimensionSize: 358, to: .width), height: adapted(dimensionSize: 766, to: .height))
    view.frame = searchFrame
    view.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    view.layer.masksToBounds = true
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
    switch tableView {
    case searchView.searchTableView:
      return coreDataManager.fetchedResultsController.sections?.count ?? 0
    case searchView.cityListTableView:
      return coreDataManager.fetchedListController.fetchedObjects?.count ?? 0
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case searchView.searchTableView:
      let sectionInfo = coreDataManager.fetchedResultsController.sections![section]
      return sectionInfo.numberOfObjects
    case searchView.cityListTableView:
      // let sectionInfo = coreDataManager.fetchedListController.sections![section]
      return 1
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return adapted(dimensionSize: 16, to: .height)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: .zero)
    headerView.backgroundColor = UIColor(named: "backgroundColor")
    return headerView
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch tableView {
    case searchView.searchTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
      var content = cell.defaultContentConfiguration()
      content.text = "\(coreDataManager.fetchedResultsController.object(at: indexPath).name) \(coreDataManager.fetchedResultsController.object(at: indexPath).country)"
      cell.backgroundColor = UIColor(named: "backgroundColor")
      cell.contentConfiguration = content
      return cell
      
    case searchView.cityListTableView:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as? CityListTableViewCell,
            let model = coreDataManager.fetchedListController.fetchedObjects?[indexPath.section]
      else { return UITableViewCell() }
      cell.configure(with: model)
      return cell
      
    default : return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch tableView {
    case searchView.searchTableView:
      let city = coreDataManager.fetchedResultsController.object(at: indexPath)
      /// сохранение выбранного города в список в КорДате
      navigationController?.dismiss(animated: false, completion: nil)

      coreDataManager.saveToList(city: city)
      coreDataManager.loadListData()
      
      let list = coreDataManager.fetchedListController.fetchedObjects ?? []
      let vc  = CityListPageViewController(for: list, index: 0)
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: false)
    case searchView.cityListTableView:
      let list = coreDataManager.fetchedListController.fetchedObjects ?? []
      let vc  = CityListPageViewController(for: list, index: indexPath.section)
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: false)

    default: return
    }
  }
  
}


extension SearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchView.searchTableView.isHidden = true
    searchView.cityListTableView.isHidden = false
    // searchView.cityListTableView.reloadData()
    // searchView.searchTableView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    /// Передеча текста в качестве предиката для фетчРеквеста
    coreDataManager.cityListPredicate = NSPredicate(format: "name CONTAINS %@", searchText)
    coreDataManager.loadSavedData()
    // print(coreDataManager.fetchedResultsController.fetchedObjects?.count)
    searchView.searchTableView.isHidden = false
    searchView.cityListTableView.isHidden = true
    searchView.searchTableView.reloadData()
    if searchText.isEmpty {
      searchView.searchTableView.isHidden = true
      searchView.cityListTableView.isHidden = false
      //searchView.cityListTableView.reloadData()
      //searchView.searchTableView.reloadData()
    }
  }
}
