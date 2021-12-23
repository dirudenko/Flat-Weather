//
//  SearchView.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class SearchView: UIView {

  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.isHidden = true
    searchBar.placeholder = "Найти город..."
    searchBar.backgroundColor = UIColor(named: "backgroundColor")
    return searchBar
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.isHidden = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.backgroundColor = UIColor(named: "backgroundColor")
    return tableView
  }()
  
  let animation: AnimationView = {
    let animation = AnimationView()
    animation.translatesAutoresizingMaskIntoConstraints = false
    return animation
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
   // backgroundColor = UIColor(named: "backgroundColor")
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayouts() {
    addSubview(searchBar)
    addSubview(tableView)
    addSubview(animation)
  }
  
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
          
      searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      searchBar.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      searchBar.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
     // searchBar.heightAnchor.constraint(equalToConstant: 50),
      
      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      animation.topAnchor.constraint(equalTo: self.centerYAnchor, constant: adapted(dimensionSize: -50, to: .height)),
      animation.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -50, to: .width)),
      animation.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .width)),
      animation.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .height))
      
    ])
    
  }
  
}
