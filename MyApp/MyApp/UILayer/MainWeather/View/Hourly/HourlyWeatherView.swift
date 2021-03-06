//
//  HourlyWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class HourlyWeatherView: UIView {
  // MARK: - Private types
  private var collectionView = CurrentWeatherCollectionView(cellType: .hourlyCollectionViewCell)
  private var dateLabel = TitleLabel(textAlignment: .center)
  private let loadingVC = LoadingView()

  private var model: MainInfo? {
    didSet {
      collectionView.reloadData()
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

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
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
      loadingVC.makeInvisible()
      model = weatherModel
    case .failure(let error):
      alertDelegate?.showAlert(text: error)
    }
  }
  // MARK: - Private functions
  private func setupFonts() {
    dateLabel.font = AppFont.bold(size: 14)
  }

  private func setupLayouts() {
    addSubview(loadingVC)
    addSubview(dateLabel)
    addSubview(collectionView)
    bringSubviewToFront(loadingVC)
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([

      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      dateLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 131, to: .width)),
     // dateLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),

      loadingVC.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      loadingVC.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}
// MARK: - UIView delegates
extension HourlyWeatherView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model?.hourlyWeather?.count != nil ? 48 : 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell,
          let model: [Hourly] =  model?.hourlyWeather?.toArray()
    else { return UICollectionViewCell() }

    cell.configure(with: model, index: indexPath.row)

    return cell
  }
}
