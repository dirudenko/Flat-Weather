//
//  SettingsViewController.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {

  private let settingsView = SettingsView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .systemBackground
      view.addSubview(settingsView)
      settingsView.settingsTableView.delegate = self
      settingsView.settingsTableView.dataSource = self
      setupConstraints()
    }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    settingsView.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    settingsView.layer.masksToBounds = true
  }
}

extension SettingsViewController {
  func setupConstraints() {
    settingsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      settingsView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      settingsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      settingsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      settingsView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 766, to: .height))
    ])
  }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return SettingsSections.allCases.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = SettingsSections(rawValue: section) else { return 0 }
    switch section {
    case .Units: return UnitOptions.allCases.count
    case .Extra: return ExtraOptions.allCases.count
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor(named: "backgroundColor")
    print("Section \(section)")
    let titleLabel = DescriptionLabel()
     titleLabel.font = AppFont.regular(size: 12)
    titleLabel.text = SettingsSections(rawValue: section)?.description
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)).isActive = true
    return view
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell,
          let section = SettingsSections(rawValue: indexPath.section) else { return UITableViewCell()}
    switch section {
    case .Units:
      let units = UnitOptions(rawValue: indexPath.row)
      cell.nameLabel.text = units?.description

    case .Extra:
      let extra = ExtraOptions(rawValue: indexPath.row)
      cell.nameLabel.text = extra?.description
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
