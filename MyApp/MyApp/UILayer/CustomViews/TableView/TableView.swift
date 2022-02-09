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
    case .cityListTableViewCell:
      super.init(frame: .zero, style: .plain)
      isHidden = false
      translatesAutoresizingMaskIntoConstraints = false
      register(CityListTableViewCell.self, forCellReuseIdentifier: "CityListTableViewCell")
      backgroundColor = UIColor.clear
      rowHeight = adapted(dimensionSize: 80, to: .height)

    case .standartTableViewCell:
      super.init(frame: .zero, style: .plain)
      isHidden = true
      translatesAutoresizingMaskIntoConstraints = false
      register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      backgroundColor = UIColor.clear

    case .weeklyTableViewCell:
      super.init(frame: .zero, style: .plain)
      translatesAutoresizingMaskIntoConstraints = false
      register(WeeklyTableViewCell.self, forCellReuseIdentifier: "WeeklyTableViewCell")
      backgroundColor = UIColor.clear
      separatorStyle = .none
      rowHeight = adapted(dimensionSize: 48, to: .height)
      allowsSelection = false

    case .settingsTableViewCell:
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

}
