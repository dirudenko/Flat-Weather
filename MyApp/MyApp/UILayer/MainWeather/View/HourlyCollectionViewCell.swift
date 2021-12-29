//
//  HourlyCollectionViewCell.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
  
  private(set) var conditionImage = MainImage(frame: .zero)
  
  private(set) var timeLabel = DescriptionLabel()
  
  private(set) var temperatureLabel = DescriptionLabel()
  
  private(set) var rainLabel = DescriptionLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(named: "backgroundColor")
    setupLayouts()
    setupFonts()
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayouts() {
    contentView.addSubview(conditionImage)
    contentView.addSubview(temperatureLabel)
    contentView.addSubview(timeLabel)
    contentView.addSubview(rainLabel)
    
    temperatureLabel.textAlignment = .center
  }
  
  private func setupFonts() {
    temperatureLabel.font = AppFont.regular(size: 19)
    timeLabel.font = AppFont.regular(size: 14)
    rainLabel.font = AppFont.regular(size: 14)
  }
  
  
  private func addConstraints() {
    
    var imageSize: CGFloat {
      adapted(dimensionSize: 24, to: .height)
    }
    
    NSLayoutConstraint.activate([
      
      timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 8, to: .height)),
      timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 18, to: .width)),
      timeLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 40, to: .width)),
      timeLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
      
      conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 36, to: .height)),
      conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 24, to: .width)),
      conditionImage.widthAnchor.constraint(equalToConstant: imageSize),
      conditionImage.heightAnchor.constraint(equalToConstant: imageSize),
      
      temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 64, to: .height)),
      temperatureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 14, to: .width)),
      temperatureLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 45, to: .width)),
      temperatureLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height)),
      
      rainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 82, to: .height)),
      rainLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 12, to: .width)),
      rainLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 50, to: .width)),
      rainLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 15, to: .height))
    ])
  }
  
  func configure(with model: HourlyWeather, index: Int) {
    rainLabel.text = "\(model.hourly[index].clouds)% дождь"
    
    var imageName =  IconHadler.iconDictionary.keyedValue(key: model.hourly[index].weather.first?.id ?? 0)
    if ((imageName?.contains(".fill")) != nil) {
      let newImageName = imageName?.replacingOccurrences(of: ".fill", with: "")
      imageName = newImageName
    }
    conditionImage.image = UIImage(systemName: imageName ?? "thermometer.sun")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    
    temperatureLabel.text = "\(Int(model.hourly[index].feelsLike))°/\(Int(model.hourly[index].temp))°"
    if index == 0 {
      timeLabel.text = "Сейчас"
    } else {
      let date = Date(timeIntervalSince1970: TimeInterval(model.hourly[index].dt)).dateHourFormatter()
      timeLabel.text = "\(date)"
    }
  }
}

