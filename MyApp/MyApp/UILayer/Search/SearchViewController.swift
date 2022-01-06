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
//  override func loadView() {
//    super.loadView()
//    self.view = searchView
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(searchView)
    setupConstraints()
    searchView.searchBar.delegate = self
    searchView.searchTableView.delegate = self
    searchView.searchTableView.dataSource = self
    searchView.cityListTableView.delegate = self
    searchView.cityListTableView.dataSource = self
    searchView.backgroundColor = UIColor(named: "backgroundColor")
    fetchDataFromCoreData()
    
    view.backgroundColor = .systemBackground
  }
  
  deinit {
    print("SearchVC deleted")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    searchView.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    searchView.layer.masksToBounds = true
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
            self.coreDataManager.loadListData()
            self.searchView.animation.removeFromSuperview()
            self.searchView.searchBar.isHidden = false
            self.searchView.searchBar.becomeFirstResponder()

          }
        case .failure(let error):
          print(error.rawValue)
        }
      }
    } else {
      self.coreDataManager.loadListData()
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
      return coreDataManager.fetchedListController.sections?.count ?? 0
    case searchView.cityListTableView:
      return coreDataManager.fetchedResultsController.fetchedObjects?.count ?? 0
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case searchView.searchTableView:
      let sectionInfo = coreDataManager.fetchedListController.sections![section]
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
      content.text = "\(coreDataManager.fetchedListController.object(at: indexPath).name) \(coreDataManager.fetchedListController.object(at: indexPath).country)"
      cell.backgroundColor = UIColor(named: "backgroundColor")
      cell.contentConfiguration = content
      return cell
      
    case searchView.cityListTableView:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as? CityListTableViewCell,
            let model = coreDataManager.fetchedResultsController.fetchedObjects?[indexPath.section]
      else { return UITableViewCell() }
  //    cell.configure(with: model)
      return cell
      
    default : return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch tableView {
    case searchView.searchTableView:
      //navigationController?.dismiss(animated: false, completion: nil)
      /// сохранение выбранного города в список в КорДате
      let city = coreDataManager.fetchedListController.object(at: indexPath)
      coreDataManager.saveToList(city: city)
      coreDataManager.loadSavedData()
      let list = coreDataManager.fetchedResultsController.fetchedObjects ?? []
      let vc  = CityListPageViewController(for: list, index: list.count - 1)
      navigationController?.setViewControllers([vc], animated: true)

//      let navigationController = UINavigationController(rootViewController: vc)
//      navigationController.modalPresentationStyle = .fullScreen
//      present(navigationController, animated: false)
    case searchView.cityListTableView:
//      navigationController?.dismiss(animated: false, completion: nil)
      let list = coreDataManager.fetchedResultsController.fetchedObjects ?? []
      let vc  = CityListPageViewController(for: list, index: indexPath.section)
//      let navigationController = UINavigationController(rootViewController: vc)
//      navigationController.modalPresentationStyle = .fullScreen
//      present(navigationController, animated: false)
      navigationController?.setViewControllers([vc], animated: true)

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
    coreDataManager.loadListData()
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

extension SearchViewController{
  func setupConstraints() {
  searchView.translatesAutoresizingMaskIntoConstraints = false
//    let searchFrame = CGRect(x: adapted(dimensionSize: 16, to: .width), y: adapted(dimensionSize: 62, to: .height), width: adapted(dimensionSize: 358, to: .width), height: adapted(dimensionSize: 766, to: .height))
//    view.frame = searchFrame
    NSLayoutConstraint.activate([
    
      
      searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      searchView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 766, to: .height))
    ])

  }

}
