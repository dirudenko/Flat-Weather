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
      backgroundColor = UIColor(named: "backgroundColor")
      rowHeight = adapted(dimensionSize: 80, to: .height)
      
    case .StandartTableViewCell:
      super.init(frame: .zero, style: .plain)
      isHidden = true
      translatesAutoresizingMaskIntoConstraints = false
      register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      backgroundColor = UIColor(named: "backgroundColor")
      
    case .WeeklyTableViewCell:
      super.init(frame: .zero, style: .plain)
      translatesAutoresizingMaskIntoConstraints = false
      register(WeeklyTableViewCell.self, forCellReuseIdentifier: "WeeklyTableViewCell")
      backgroundColor = UIColor(named: "backgroundColor")
      separatorStyle = .none
      rowHeight = adapted(dimensionSize: 48, to: .height)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
