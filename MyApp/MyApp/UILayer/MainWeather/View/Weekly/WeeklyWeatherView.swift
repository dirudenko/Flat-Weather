//
//  WeeklyWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 28.12.2021.
//

import UIKit

class WeeklyWeatherView: UIView {
  // MARK: - Private types
  private let weeklyListTableView = TableView(celltype: .weeklyTableViewCell)
  private(set) var dateLabel = TitleLabel(textAlignment: .center)
  private let loadingVC = LoadingView()
  private var model: MainInfo? {
    didSet {
      weeklyListTableView.reloadData()
    }
  }
  // MARK: - Public types
  weak var alertDelegate: AlertProtocol?
  var viewData: MainViewData = .initial {
    didSet {
      setNeedsLayout()
    }
  }
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupFonts()
    addConstraints()
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
      loadingVC.makeVisible()
    case .fetching(let weatherModel):
      model = weatherModel
      loadingVC.makeInvisible()
    case .success(let weatherModel):
      model = weatherModel
      loadingVC.makeInvisible()
    case .failure(let error):
      alertDelegate?.showAlert(text: error)
    }
  }
  // MARK: - Private functions
  private func setupLayouts() {
    addSubview(weeklyListTableView)
    addSubview(dateLabel)
    addSubview(loadingVC)
    backgroundColor = UIColor(named: "bottomColor")
    weeklyListTableView.delegate = self
    weeklyListTableView.dataSource = self
  }

  private func setupFonts() {
    dateLabel.font = AppFont.regular(size: 16)
    let weeklyWeatherLabel = NSLocalizedString("weeklyWeatherLabel", comment: "weeklyWeather Button Label")
    dateLabel.text = weeklyWeatherLabel
  }

  private func addConstraints() {

    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
     // dateLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 20, to: .height)),

      weeklyListTableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
      weeklyListTableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      weeklyListTableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      weeklyListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      loadingVC.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      loadingVC.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}
extension WeeklyWeatherView: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model?.weeklyWeather?.count != nil ? 7 : 0
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
