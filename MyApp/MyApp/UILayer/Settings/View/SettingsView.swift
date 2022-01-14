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
  
  private(set) var unitsTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.rowHeight = adapted(dimensionSize: 32, to: .height)
    // tableView.rowHeight = UITableView.automaticDimension;
    //  tableView.estimatedRowHeight = 44.0
    // var frame = tableView.frame
    //    frame.size.height = tableView.contentSize.height;
    //    tableView.frame = CGRect(x: 100, y: 100, width: frame.width, height: frame.height)
    tableView.isHidden = true
    
    tableView.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    tableView.layer.masksToBounds = true
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
    addSubview(unitsTableView)
    backgroundColor = UIColor(named: "backgroundColor")
  }
  
  
  
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      settingsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      settingsTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      settingsTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      settingsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      unitsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      unitsTableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      unitsTableView.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 120, to: .width)),
      
    ])
  }
}
