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
    searchBar.placeholder = "Найти город..."
    searchBar.searchTextField.layer.cornerRadius = 16
    searchBar.searchTextField.borderStyle = .roundedRect
    searchBar.isHidden = true
    searchBar.barTintColor = UIColor(named: "backgroundColor")
    searchBar.searchTextField.backgroundColor = .systemGray6
    return searchBar
  }()
  
  let searchTableView: UITableView = {
    let tableView = UITableView()
    tableView.isHidden = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.backgroundColor = UIColor(named: "backgroundColor")
    return tableView
  }()
  
  let cityListTableView: UITableView = {
    let tableView = UITableView()
    tableView.isHidden = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    //tableView.contentInset = UIEdgeInsets(top: 144, left: 16, bottom: 542, right: 16)
    tableView.register(CityListTableViewCell.self, forCellReuseIdentifier: "CityListTableViewCell")
    tableView.backgroundColor = UIColor(named: "backgroundColor")
    tableView.rowHeight = adapted(dimensionSize: 80, to: .height)
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
    addSubview(searchTableView)
    addSubview(cityListTableView)
    addSubview(animation)
  }
  
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
          
      searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      searchBar.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      searchBar.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      searchBar.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 50, to: .height)),
      
      searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      searchTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      searchTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      searchTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      cityListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      cityListTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      cityListTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      cityListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      animation.topAnchor.constraint(equalTo: self.centerYAnchor, constant: adapted(dimensionSize: -50, to: .height)),
      animation.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -50, to: .width)),
      animation.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .width)),
      animation.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .height))
      
    ])
  }
}
