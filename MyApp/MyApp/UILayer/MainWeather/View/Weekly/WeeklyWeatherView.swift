//
//  WeeklyWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 28.12.2021.
//

import UIKit

class WeeklyWeatherView: UIView {
  // MARK: - Private types
  private let weeklyListTableView = TableView(celltype: .WeeklyTableViewCell)
  private(set) var dateLabel = TitleLabel(textAlignment: .center)
  private var model: MainInfo? {
    didSet {
      weeklyListTableView.reloadData()
    }
  }
  // MARK: - Public types
  var viewData: MainViewData = .initial {
    didSet {
      setNeedsLayout()
    }
  }
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupLayouts()
    addConstraints()
    setupFonts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    switch viewData {
    case .initial:
      break
    case .loading:
      break
    case .fetching(let weatherModel):
      model = weatherModel
    case .success(let weatherModel):
      model = weatherModel
    case .failure:
      // TODO: Show Error
      break
    }
  }
  // MARK: - Private functions
  private func setupLayouts() {
    addSubview(weeklyListTableView)
    addSubview(dateLabel)
    backgroundColor = UIColor(named: "backgroundColor")
    weeklyListTableView.delegate = self
    weeklyListTableView.dataSource = self
  }
  
  private func setupFonts() {
    dateLabel.font = AppFont.regular(size: 16)
    dateLabel.text = "Forecast 7 days"
  }
  
  private func addConstraints() {
    
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      dateLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
      
      weeklyListTableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
      weeklyListTableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      weeklyListTableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      weeklyListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}
extension WeeklyWeatherView: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model?.weeklyWeather?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell", for: indexPath) as? WeeklyTableViewCell,
          let model: [Weekly] =  model?.weeklyWeather?.toArray() else { return UITableViewCell() }
    cell.configure(with: model[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}


