//
//  SettingsView.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit

protocol SettingsViewProtocol {
  func backButtonTapped()
}

class SettingsView: UIView {
  // MARK: - Private types
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
    tableView.isHidden = true
    tableView.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    tableView.layer.masksToBounds = true
    return tableView
  }()
  
  private(set) var backButton = Button(backgroundColor: UIColor(named: "backgroundColor")!, systemImage: "arrow.backward")
  // MARK: - Public variables
  var delegate: SettingsViewProtocol?
  // MARK: - Initialization  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Private functions

  private func setupLayouts() {
    addSubview(settingsTableView)
    addSubview(unitsTableView)
    addSubview(backButton)
    backgroundColor = UIColor(named: "backgroundColor")
    backButton.addTarget(self, action: #selector(didTapBack), for: .touchDown)
  }
  
  @objc private func didTapBack() {
    delegate?.backButtonTapped()
  }
  
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      settingsTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      settingsTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      settingsTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      settingsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      unitsTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      unitsTableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      unitsTableView.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 120, to: .width)),
      
      backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      backButton.widthAnchor.constraint(equalToConstant: 32),
      backButton.heightAnchor.constraint(equalToConstant: 32)
      
    ])
  }
}
