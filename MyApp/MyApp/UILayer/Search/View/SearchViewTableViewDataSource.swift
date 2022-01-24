////
////  SearchViewTableViewDataSource.swift
////  MyApp
////
////  Created by Dmitry on 24.01.2022.
////
//
//import UIKit
//
//class CitiListTableViewDataSource: NSObject, UITableViewDataSource {
//
//  typealias CellConfigurator = (MainInfo, UITableViewCell) -> Void
//
//      var models: [MainInfo]
//
//      private let reuseIdentifier: String
//      private let cellConfigurator: CellConfigurator
//
//      init(models: [MainInfo],
//           reuseIdentifier: String,
//           cellConfigurator: @escaping CellConfigurator) {
//          self.models = models
//          self.reuseIdentifier = reuseIdentifier
//          self.cellConfigurator = cellConfigurator
//      }
//
//
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return models.count
//  }
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//      return models.count
//  }
//
//
//
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let model = models[indexPath.row]
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: reuseIdentifier,
//            for: indexPath
//        )
//    cellConfigurator(model,cell)
//  }
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//    switch tableView {
//    case searchTableView:
//      let model = searchViewCellModel.setCity(model: city[indexPath.row], for: .StandartTableViewCell)
//      delegate?.setViewFromCityList(fot: model, at: model.count - 1)
//    case cityListTableView:
//      let model = searchViewCellModel.setCity(model: nil, for: .CityListTableViewCell)
//      delegate?.setViewFromCityList(fot: model, at: indexPath.section)
//    default: return
//    }
//  }
//
//  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//      return true
//
//  }
//
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    switch tableView {
//    case searchTableView:
//      return
//    case cityListTableView:
//      if editingStyle == .delete
//      {
//        searchViewCellModel.removeObject(at: indexPath.section)
//        if searchViewCellModel.coreDataManager.entityIsEmpty() {
//          backButton.isHidden = true
//        }
//      }
//    default: return
//    }
//  }
//
//
//
//
//
//}
