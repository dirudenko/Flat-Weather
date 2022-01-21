//
//  TableView.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import UIKit

class TableView: UITableView {

  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
  }
  
  init(celltype: TableViewCellTypes) {
    switch celltype {
    case .CityListTableViewCell:
      super.init(frame: .zero, style: .plain)
      isHidden = false
      translatesAutoresizingMaskIntoConstraints = false
      register(CityListTableViewCell.self, forCellReuseIdentifier: "CityListTableViewCell")
      backgroundColor = UIColor.clear
      rowHeight = adapted(dimensionSize: 80, to: .height)
      
    case .StandartTableViewCell:
      super.init(frame: .zero, style: .plain)
      isHidden = true
      translatesAutoresizingMaskIntoConstraints = false
      register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      backgroundColor = UIColor.clear

    case .WeeklyTableViewCell:
      super.init(frame: .zero, style: .plain)
      translatesAutoresizingMaskIntoConstraints = false
      register(WeeklyTableViewCell.self, forCellReuseIdentifier: "WeeklyTableViewCell")
      backgroundColor = UIColor.clear
      separatorStyle = .none
      rowHeight = adapted(dimensionSize: 48, to: .height)
      allowsSelection = false
  
    case .SettingsTableViewCell:
      super.init(frame: .zero, style: .plain)
      register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
      backgroundColor = UIColor.clear
      separatorStyle = .none
      rowHeight = adapted(dimensionSize: 32, to: .height)
      isScrollEnabled = false
      translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureForSettings() {
    self.backgroundColor = .white
    self.separatorStyle = .none
    self.rowHeight = adapted(dimensionSize: 32, to: .height)
    self.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    self.layer.masksToBounds = true
  }
  
  
}
