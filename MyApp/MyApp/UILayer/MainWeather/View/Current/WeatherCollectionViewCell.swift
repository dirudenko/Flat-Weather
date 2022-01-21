//
//  WeatherCollectionViewCell.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
  // MARK: - Private types
  private(set)  var conditionImage = MainImage(frame: .zero)
  private(set)  var conditionStatusLabel = DescriptionLabel()
  private(set)  var conditionNameLabel = DescriptionLabel()
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clear
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
  }
  
  private func setupFonts() {
    conditionStatusLabel.font = AppFont.regular(size: 12)
    conditionNameLabel.font =  AppFont.regular(size: 12)
  }
  
  
  private func addConstraints() {
    var imageSize: CGFloat {
      adapted(dimensionSize: 32, to: .height)
    }
    
    NSLayoutConstraint.activate([
      
      conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      conditionImage.widthAnchor.constraint(equalToConstant: imageSize),
      conditionImage.heightAnchor.constraint(equalToConstant: imageSize),
      
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
      conditionStatusLabel.text = "\(bottomBar.wind) km/h"
      conditionNameLabel.text = "Wind"
    case 1:
      conditionImage.image = UIImage(systemName: "cloud.drizzle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(bottomBar.rain)%"
      conditionNameLabel.text = "Rain"
    case 2:
      conditionImage.image = UIImage(systemName: "thermometer")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(bottomBar.pressure) mBar"
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

