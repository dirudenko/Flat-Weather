//
//  WeatherCollectionViewCell.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
  
  private(set)  var conditionImage = MainImage(frame: .zero)
  private(set)  var conditionStatusLabel = DescriptionLabel()
  private(set)  var conditionNameLabel = DescriptionLabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(named: "backgroundColor")
    setupLayouts()
    addConstraints()
    setupFonts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
  
  func configure(with model: CurrentWeather, index: Int) {
    switch index {
    case 0:
      conditionImage.image = UIImage(systemName: "wind")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(model.wind.speed) km/h"
      conditionNameLabel.text = "Ветер"
    case 1:
      conditionImage.image = UIImage(systemName: "cloud.drizzle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(model.clouds.all)%"
      conditionNameLabel.text = "Дождь"
    case 2:
      conditionImage.image = UIImage(systemName: "thermometer")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(model.main.pressure) mBar"
      conditionNameLabel.text = "Давление"
    case 3:
      conditionImage.image = UIImage(systemName: "humidity")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      conditionStatusLabel.text = "\(model.main.humidity) %"
      conditionNameLabel.text = "Влажность"
    default:
      break
    }
  }
}

