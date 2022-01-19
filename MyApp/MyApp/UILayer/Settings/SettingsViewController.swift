//
//  SettingsViewController.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {
  // MARK: - Private types
  private let settingsView = SettingsView()
  private var unitOption: UnitOptions?
  // MARK: - Private variables
  private var dataType = [String]()
  /// констрейнт для высоты таблицы
  private var flowHeightConstraint: NSLayoutConstraint?
  // MARK: - UIViewController lifecycle methods

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    settingsView.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    settingsView.layer.masksToBounds = true
    
  }
  // MARK: - Private functions
  private func setupViews() {
    view.backgroundColor = .systemBackground
    self.navigationItem.setHidesBackButton(true, animated: false)
    view.addSubview(settingsView)
    settingsView.settingsTableView.delegate = self
    settingsView.settingsTableView.dataSource = self
    settingsView.unitsTableView.delegate = self
    settingsView.unitsTableView.dataSource = self
    settingsView.delegate = self
  }
  
  private func setupConstraints() {
    settingsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      settingsView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      settingsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      settingsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      settingsView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 766, to: .height))
    ])
    flowHeightConstraint = settingsView.unitsTableView.heightAnchor.constraint(equalToConstant: 64)
    flowHeightConstraint?.isActive = true
  }
}
// MARK: - UIViewController delegates

extension SettingsViewController: SettingsViewProtocol {
  func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UITableView delegates

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    switch tableView {
    case settingsView.settingsTableView: return SettingsSections.allCases.count
    case settingsView.unitsTableView: return 1
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case settingsView.settingsTableView:
      
      guard let section = SettingsSections(rawValue: section) else { return 0 }
      switch section {
      case .Units: return UnitOptions.allCases.count
      case .Extra: return ExtraOptions.allCases.count
      }
    case settingsView.unitsTableView:
      
      return dataType.count
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if tableView == settingsView.settingsTableView {
      let view = UIView()
      view.backgroundColor = UIColor(named: "backgroundColor")
      let titleLabel = DescriptionLabel()
      titleLabel.font = AppFont.regular(size: 12)
      titleLabel.text = SettingsSections(rawValue: section)?.description
      view.addSubview(titleLabel)
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)).isActive = true
      return view
    } else {
      return UIView(frame: .zero)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case settingsView.settingsTableView:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell,
            let section = SettingsSections(rawValue: indexPath.section) else { return UITableViewCell() }
      switch section {
      case .Units:
        let units = UnitOptions(rawValue: indexPath.row)
        // cell.nameLabel.text = units?.description
        cell.unitsType = units
      case .Extra:
        let extra = ExtraOptions(rawValue: indexPath.row)
        cell.nameLabel.text = extra?.description
        cell.unitLabel.text = ""
      }
      return cell
    case settingsView.unitsTableView:
      if dataType.count > 0 {
        let height = settingsView.unitsTableView.rowHeight * CGFloat(dataType.count + 2)
        self.flowHeightConstraint?.constant = height
        self.view.layoutIfNeeded()
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
      cell.textLabel?.text = dataType[indexPath.row]
      return cell
      
    default: return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch tableView {
    case settingsView.settingsTableView:
      let section = SettingsSections(rawValue: indexPath.section)
      
      switch section {
      case .Units:
        switch indexPath.row {
        case 0:
          dataType.removeAll()
          Temperature.allCases.forEach { dataType.append($0.description) }
          unitOption = .temperature
         // view.layoutIfNeeded()
         // view.reloadInputViews()
          settingsView.unitsTableView.isHidden = false
          settingsView.unitsTableView.reloadData()
        case 1:
          dataType.removeAll()
          WindSpeed.allCases.forEach { dataType.append($0.description) }
          unitOption = .wind
          
          settingsView.unitsTableView.isHidden = false
          settingsView.unitsTableView.reloadData()
        case 2:
          dataType.removeAll()
          Pressure.allCases.forEach {  dataType.append($0.description) }
          unitOption = .pressure
          settingsView.unitsTableView.isHidden = false
          settingsView.unitsTableView.reloadData()
        default: break
        }
      case .Extra:
        break
      default: break
      }
    case settingsView.unitsTableView:
      let unit = dataType[indexPath.row]
      guard let unitName = unitOption?.description.components(separatedBy: " ").first else { return }
      UserDefaultsManager.set(unit,forKey: unitName)
      settingsView.unitsTableView.isHidden = true
      settingsView.settingsTableView.reloadData()
    default: break
    }
  }
  
  
  
}
