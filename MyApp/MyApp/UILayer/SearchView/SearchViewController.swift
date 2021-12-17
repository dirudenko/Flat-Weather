//
//  SearchViewController.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class SearchViewController: UIViewController {
  
  private let searchView = SearchView()
  private var searchResult = String()
  private var citilist = [CitiList]()
  private var foundedCities = [CitiList]()
  
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
      DispatchQueue.global(qos: .utility) .async {
        self.decodeList { result in
          switch result {
          case .success(let list):
            DispatchQueue.main.async {
              self.citilist = list
              self.searchView.animation.removeFromSuperview()
              self.searchView.searchBar.isHidden = false
            }
          case .failure(let error):
            print(error.rawValue)
          }
        }
      }
      
    }
  
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

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return foundedCities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
    var content = cell.defaultContentConfiguration()
    content.text = foundedCities[indexPath.row].name
    cell.backgroundColor = UIColor(named: "backgroundColor")
    
    cell.contentConfiguration = content
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    print(foundedCities[indexPath.row])
  }
}


extension SearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchResult.removeAll()
    searchView.tableView.isHidden = true
    searchView.tableView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    foundedCities.removeAll()
    
    searchResult = searchText
    if !searchResult.isEmpty {
    citilist.forEach {
      if $0.name.contains(searchResult.capitalizedFirstLetter) {
        foundedCities.append($0)
      }
    }
    }
    searchView.tableView.isHidden = false
    searchView.tableView.reloadData()
  }

//  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//      guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
//        return
//      }
//    searchView.searchBar.resignFirstResponder()
//    searchResult.removeAll()
//    searchResult = text
//    searchView.tableView.isHidden = false
//    searchView.tableView.reloadData()
//  }
  
}
