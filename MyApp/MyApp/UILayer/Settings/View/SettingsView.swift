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
  func privacyPressed()
  func aboutPressed()
}

class SettingsView: UIView {
  // MARK: - Private types
  private let settingsTableView = CustomTableView(celltype: .settingsTableViewCell)
  private var picker: Picker?
  private let gradient = Constants.Design.gradient
  private let backButton = Button(systemImage: "arrow.backward")
  // MARK: - Public variables
  weak var delegate: SettingsViewProtocol?
  
  var viewData: SettingsViewData = .initial {
    didSet {
      setNeedsLayout()
    }
  }
  // MARK: - Private variables
  /// данные(размерности) выбранного типа
  private var dataType = [Settings]()
  /// выбранный тип данных для изменения
  private var unitOption: UnitOptions?
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupViews()
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Data Driven состояние для View
  override func layoutSubviews() {
    super.layoutSubviews()
    gradient.frame = self.bounds
    switch viewData {
    case .initial:
      break
    case .loading:
      picker?.isHidden = false
      picker?.reloadComponent(0)
    case .success:
      picker?.isHidden = true
      settingsTableView.reloadData()
    case .failure:
      break
    }
    
  }
  // MARK: - Private functions
  
  private func setupLayouts() {
    addSubview(settingsTableView)
    addSubview(backButton)
    layer.insertSublayer(gradient, at: 0)
  }
  
  private func setupViews() {
    picker = Picker(for: self)
    settingsTableView.delegate = self
    settingsTableView.dataSource = self
    picker?.dataSource = self
    picker?.delegate = self
    backButton.addTarget(self, action: #selector(didTapBack), for: .touchDown)
//    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
//    addGestureRecognizer(panGestureRecognizer)
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
      if translation.x > adapted(dimensionSize: 30, to: .width) {
        delegate?.backButtonTapped()
      }
    case .ended:
      break
    default:
      break
    }
  }
  /// сортировка данных для вывода текущего значения первым по списку
  private func sortDataType(data: [Settings], currentUnit: UnitOptions?) -> [Settings] {
    var unitIndex: Int?
    
    switch currentUnit {
    case .temperature:
      let temperature: Temperature? = UserDefaultsManager.get(forKey: "Temperature")
      for (index, item) in data.enumerated() where item.description == temperature?.description {
        unitIndex = index
      }
      
    case .wind:
      let wind: WindSpeed? = UserDefaultsManager.get(forKey: "Wind")
      for (index, item) in data.enumerated() where item.description == wind?.description {
        unitIndex = index
      }
    case .pressure:
      let pressure: Pressure? = UserDefaultsManager.get(forKey: "Pressure")
      for (index, item) in data.enumerated() where item.description == pressure?.description {
        unitIndex = index
      }
    default: break
    }
    
    var newData = data
    newData.swapAt(0, unitIndex ?? 0)
    return newData
  }
  
}

// MARK: - UIPickerView delegates

extension SettingsView: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return dataType.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return dataType[row].description
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    let unit = dataType[row]
    delegate?.unitChanged(unit: unit, type: unitOption)
  }
  
}

// MARK: - UITableView delegates

extension SettingsView: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return SettingsSections.allCases.count
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = SettingsSections(rawValue: section) else { return 0 }
    switch section {
    case .units: return UnitOptions.allCases.count
    case .extra: return ExtraOptions.allCases.count
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch tableView {
    case settingsTableView:
      let view = UIView()
      view.backgroundColor = .clear
      let titleLabel = DescriptionLabel()
      titleLabel.font = Constants.Fonts.small
      titleLabel.text = SettingsSections(rawValue: section)?.description
      view.addSubview(titleLabel)
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.Design.horizontalViewPadding).isActive = true
      return view
    default:
      return UIView(frame: .zero)
    }
  }  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell,
          let section = SettingsSections(rawValue: indexPath.section) else { return UITableViewCell() }
    switch section {
    case .units:
      let units = UnitOptions(rawValue: indexPath.row)
      cell.unitsType = units
    case .extra:
      let extra = ExtraOptions(rawValue: indexPath.row)
      cell.nameLabel.text = extra?.description
      cell.unitLabel.text = ""
    }
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let section = SettingsSections(rawValue: indexPath.section)
    switch section {
    case .units:
      switch indexPath.row {
      case 0:
        dataType.removeAll()
        Temperature.allCases.forEach { dataType.append($0) }
        unitOption = .temperature
        dataType =  sortDataType(data: dataType, currentUnit: unitOption)
        delegate?.unitPressed()
      case 1:
        dataType.removeAll()
        WindSpeed.allCases.forEach { dataType.append($0) }
        unitOption = .wind
        dataType =  sortDataType(data: dataType, currentUnit: unitOption)
        delegate?.unitPressed()
      case 2:
        dataType.removeAll()
        Pressure.allCases.forEach {  dataType.append($0) }
        unitOption = .pressure
        dataType =  sortDataType(data: dataType, currentUnit: unitOption)
        delegate?.unitPressed()
      default: break
      }
    case .extra:
      switch indexPath.row {
      case 0:
        delegate?.aboutPressed()
      case 1:
        delegate?.privacyPressed()
      default:
        break
      }
    default: break
    }
  }
}

// MARK: - Constraints
extension SettingsView {
  private func addConstraints() {
    NSLayoutConstraint.activate([
      settingsTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      settingsTableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.Design.horizontalViewPadding),
      settingsTableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.Design.horizontalViewPadding),
      settingsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.Design.verticalViewPadding),
      backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.Design.horizontalViewPadding),
      backButton.widthAnchor.constraint(equalToConstant: Constants.Design.buttonSize),
      backButton.heightAnchor.constraint(equalToConstant: Constants.Design.buttonSize)
      
    ])
  }
}
