//
//  SettingsView.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
  func backButtonTapped()
  func unitChanged(unit: Settings, type: UnitOptions?)
  func unitPressed()
}

class SettingsView: UIView {
  // MARK: - Private types
  private let settingsTableView = TableView(celltype: .SettingsTableViewCell)
  
  private let unitsTableView = TableView(celltype: .StandartTableViewCell)
  private let gradient = Constants.Design.gradient
  private let backButton = Button(systemImage: "arrow.backward")
  // MARK: - Public variables
  var delegate: SettingsViewProtocol?
  
  var viewData: SettingsViewData = .initial {
    didSet {
      setNeedsLayout()
    }
  }
  // MARK: - Private variables
  private var dataType = [Settings]()
  private var type: UnitOptions?
  /// констрейнт для высоты таблицы
  private var flowHeightConstraint: NSLayoutConstraint?
  // private var initialCenter: CGPoint = .zero
  private var unitOption: UnitOptions?

  
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
  
  /// Data Driven состояние для вьюшки
  override func layoutSubviews() {
    super.layoutSubviews()
    gradient.frame = self.bounds
    switch viewData {
    case .initial:
      break
    case .loading:
      unitsTableView.isHidden = false
      unitsTableView.reloadData()
    case .success:
      unitsTableView.isHidden = true
      dataType.removeAll()
      settingsTableView.reloadData()
    case .failure:
      break
    }
    
  }
  // MARK: - Private functions
  
  private func setupLayouts() {
    unitsTableView.configureForSettings()
    addSubview(settingsTableView)
    addSubview(unitsTableView)
    addSubview(backButton)
    settingsTableView.delegate = self
    settingsTableView.dataSource = self
    unitsTableView.delegate = self
    unitsTableView.dataSource = self
    backButton.addTarget(self, action: #selector(didTapBack), for: .touchDown)
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    addGestureRecognizer(panGestureRecognizer)
    layer.insertSublayer(gradient, at:0)
  }
  
  @objc private func didTapBack() {
    delegate?.backButtonTapped()
  }
  
  @objc private func didPan(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .began:
      break
    case .changed:
      let translation = sender.translation(in: self)
      //self.center = CGPoint(x: initialCenter.x + translation.x,
      // y: initialCenter.y + translation.y)
      if translation.x > adapted(dimensionSize: 30, to: .width) {
        delegate?.backButtonTapped()
      }
    case .ended:
      break
    default:
      break
    }
  }
}

// MARK: - UITableView delegates

extension SettingsView: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    switch tableView {
    case settingsTableView: return SettingsSections.allCases.count
    case unitsTableView: return 1
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case settingsTableView:
      
      guard let section = SettingsSections(rawValue: section) else { return 0 }
      switch section {
      case .Units: return UnitOptions.allCases.count
      case .Extra: return ExtraOptions.allCases.count
      }
    case unitsTableView:
      return dataType.count
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch tableView {
    case settingsTableView:
      let view = UIView()
      view.backgroundColor = .clear
      let titleLabel = DescriptionLabel()
      titleLabel.font = AppFont.regular(size: 12)
      titleLabel.text = SettingsSections(rawValue: section)?.description
      view.addSubview(titleLabel)
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)).isActive = true
      return view
    default:
      return UIView(frame: .zero)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case settingsTableView:
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
    case unitsTableView:
      if dataType.count > 0 {
        let height = unitsTableView.rowHeight * CGFloat(dataType.count + 2)
        self.flowHeightConstraint?.constant = height
        layoutIfNeeded()
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
      cell.textLabel?.text = dataType[indexPath.row].description
      return cell
      
    default: return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch tableView {
    case settingsTableView:
      let section = SettingsSections(rawValue: indexPath.section)
      switch section {
      case .Units:
        switch indexPath.row {
        case 0:
          Temperature.allCases.forEach { dataType.append($0) }
          unitOption = .temperature
          delegate?.unitPressed()
        case 1:
          WindSpeed.allCases.forEach { dataType.append($0) }
          unitOption = .wind
          delegate?.unitPressed()
        case 2:
          Pressure.allCases.forEach {  dataType.append($0) }
          unitOption = .pressure
          delegate?.unitPressed()

        default: break
        }
      case .Extra:
        break
      default: break
      }
    case unitsTableView:
      let unit = dataType[indexPath.row]
      delegate?.unitChanged(unit: unit, type: unitOption)
    default: break
    }
  }
}


// MARK: - Constraints
extension SettingsView {
  private func addConstraints() {
    NSLayoutConstraint.activate([
      settingsTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      settingsTableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      settingsTableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      settingsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      unitsTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      unitsTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      unitsTableView.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 120, to: .width)),
      
      backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      backButton.widthAnchor.constraint(equalToConstant: 32),
      backButton.heightAnchor.constraint(equalToConstant: 32)
      
      
      
    ])
    flowHeightConstraint = unitsTableView.heightAnchor.constraint(equalToConstant: 64)
    flowHeightConstraint?.isActive = true
  }
}
