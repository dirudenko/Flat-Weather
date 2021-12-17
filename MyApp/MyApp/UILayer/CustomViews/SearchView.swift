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
    addSubview(searchBar)
    addSubview(tableView)
    addSubview(animation)
   // backgroundColor = UIColor(named: "backgroundColor")
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
          
      searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 9),
      searchBar.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
      searchBar.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
     // searchBar.heightAnchor.constraint(equalToConstant: 50),
      
      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 9),
      tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
      tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 16),
      tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      animation.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
      animation.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -50),
      animation.widthAnchor.constraint(equalToConstant: 200),
      animation.heightAnchor.constraint(equalToConstant: 200)
      
    ])
    
  }
  
}
