//
//  SearchTableView.swift
//  MyApp
//
//  Created by Dmitry on 23.12.2021.
//

import UIKit


class SearchTableView : NSObject, UITableViewDataSource {
  
  private let searchView = SearchView()
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  
  func numberOfSections(in tableView: UITableView) -> Int {
    switch tableView {
    case searchView.searchTableView:
    return coreDataManager.fetchedResultsController.sections?.count ?? 0
    default: return 0
    }
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
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//    let city = coreDataManager.fetchedResultsController.object(at: indexPath)
///// сохранение выбранного города в список в КорДате
//    coreDataManager.saveToList(city: city)
//    coreDataManager.saveContext()
//    navigationController?.dismiss(animated: false, completion: nil)
//
//    let list = coreDataManager.fetchedListController.fetchedObjects ?? []
//    let vc  = MainWeatherViewController(for: list)
//    vc.modalPresentationStyle = .fullScreen
//    present(vc, animated: false)
    
 // }
}
