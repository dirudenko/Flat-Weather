//
//  SettingsView.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit

class SettingsView: UIView {
  
  private(set) var settingsTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
    tableView.backgroundColor = UIColor(named: "backgroundColor")
    tableView.separatorStyle = .none
    tableView.rowHeight = adapted(dimensionSize: 32, to: .height)
    tableView.isScrollEnabled = false
    return tableView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
 
  private func setupLayouts() {
    addSubview(settingsTableView)
    backgroundColor = UIColor(named: "backgroundColor")

  }



private func addConstraints() {
  let safeArea = self.safeAreaLayoutGuide
  NSLayoutConstraint.activate([
    settingsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
    settingsTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
    settingsTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
    settingsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    
  ])
}
}
