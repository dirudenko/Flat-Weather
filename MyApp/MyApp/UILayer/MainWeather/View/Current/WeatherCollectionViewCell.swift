//
//  WeatherCollectionViewCell.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
  // MARK: - Private types
  private let conditionImage = MainImage(frame: .zero)
  private let conditionStatusLabel = DescriptionLabel()
  private let conditionNameLabel = DescriptionLabel()
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
  // MARK: - Private functions
  private func setupLayouts() {
    contentView.addSubview(conditionImage)
    contentView.addSubview(conditionNameLabel)
    contentView.addSubview(conditionStatusLabel)
    backgroundColor = UIColor.clear
  }

  private func setupFonts() {
    conditionStatusLabel.font = AppFont.regular(size: 12)
    conditionNameLabel.font =  AppFont.regular(size: 12)
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([

      conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      conditionImage.widthAnchor.constraint(equalToConstant: Constants.Design.imageCellSize),
      conditionImage.heightAnchor.constraint(equalToConstant: Constants.Design.imageCellSize),

      conditionStatusLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      conditionStatusLabel.leftAnchor.constraint(equalTo: conditionImage.rightAnchor, constant: adapted(dimensionSize: 4, to: .width)),
      conditionStatusLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 50, to: .width)),
      conditionStatusLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height)),

      conditionNameLabel.topAnchor.constraint(equalTo: conditionStatusLabel.bottomAnchor, constant: adapted(dimensionSize: 5, to: .height)),
      conditionNameLabel.leftAnchor.constraint(equalTo: conditionImage.rightAnchor, constant: adapted(dimensionSize: 4, to: .width)),
      conditionNameLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 100, to: .width)),
      conditionNameLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height))
    ])
  }
  // MARK: - Public functions
   func configure(with model: MainInfo, index: Int) {
    guard let bottomBar = model.bottomWeather else { return }
    switch index {
    case 0:
      conditionImage.image = UIImage(systemName: "wind")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      let wind: WindSpeed = WindSpeed(rawValue: UserDefaultsManager.get(forKey: "Wind")!) ?? .ms
      conditionStatusLabel.text = "\(Int(bottomBar.wind)) \(wind.description)"
      conditionNameLabel.text = "Wind Speed"
    case 1:
      conditionImage.image = UIImage(systemName: "cloud.drizzle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(bottomBar.pop) %"
      conditionNameLabel.text = "Precipitation"
    case 2:
      conditionImage.image = UIImage(systemName: "thermometer")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      let pressure: Pressure = Pressure(rawValue: UserDefaultsManager.get(forKey: "Pressure")!) ?? .hPa
      conditionStatusLabel.text = "\(bottomBar.pressure) \(pressure.description)"
      conditionNameLabel.text = "Pressure"
    case 3:
      conditionImage.image = UIImage(systemName: "humidity")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(bottomBar.humidity) %"
      conditionNameLabel.text = "Humidity"
    default:
      break
    }
  }
}
