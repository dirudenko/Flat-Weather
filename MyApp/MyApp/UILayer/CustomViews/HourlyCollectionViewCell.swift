//
//  HourlyCollectionViewCell.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
  
  private let imageSize: CGFloat = 24

  private(set) lazy var conditionImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private(set) lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 19, weight: .medium)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var temperatureLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var rainLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
 // let loadingView = LoadingViewController()

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(conditionImage)
    contentView.addSubview(temperatureLabel)
    contentView.addSubview(timeLabel)
    contentView.addSubview(rainLabel)
   // contentView.addSubview(loadingView.view)
    backgroundColor = UIColor(named: "backgroundColor")
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func addConstraints() {
    
    NSLayoutConstraint.activate([
      
//      loadingView.view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//      loadingView.view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//      loadingView.view.widthAnchor.constraint(equalToConstant: imageSize),
//      loadingView.view.heightAnchor.constraint(equalToConstant: imageSize * 4),
//

      timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18),
      timeLabel.widthAnchor.constraint(equalToConstant: 40),
      timeLabel.heightAnchor.constraint(equalToConstant: 19),
      
      conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
      conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
      conditionImage.widthAnchor.constraint(equalToConstant: imageSize),
      conditionImage.heightAnchor.constraint(equalToConstant: imageSize),
      
      temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 64),
      temperatureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14),
      temperatureLabel.widthAnchor.constraint(equalToConstant: 45),
      temperatureLabel.heightAnchor.constraint(equalToConstant: 14),
      
      rainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 82),
      rainLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
      rainLabel.widthAnchor.constraint(equalToConstant: 50),
      rainLabel.heightAnchor.constraint(equalToConstant: 14)
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
    let date = Date(timeIntervalSince1970: TimeInterval(model.hourly[index].dt)).dateHourFormatter()
    timeLabel.text = "\(date)"
  }
}

