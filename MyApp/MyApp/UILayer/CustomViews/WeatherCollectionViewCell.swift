//
//  WeatherCollectionViewCell.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
  
  private let imageSize: CGFloat = 32
  
  
  private(set) lazy var conditionImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private(set) lazy var conditionStatusLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var conditionNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(conditionImage)
    contentView.addSubview(conditionNameLabel)
    contentView.addSubview(conditionStatusLabel)

    backgroundColor = UIColor(named: "backgroundColor")
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func addConstraints() {
    
    NSLayoutConstraint.activate([
      
      conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      conditionImage.widthAnchor.constraint(equalToConstant: imageSize),
      conditionImage.heightAnchor.constraint(equalToConstant: imageSize),
      
      conditionStatusLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      conditionStatusLabel.leftAnchor.constraint(equalTo: conditionImage.rightAnchor, constant: 4),
      conditionStatusLabel.widthAnchor.constraint(equalToConstant: 50),
      conditionStatusLabel.heightAnchor.constraint(equalToConstant: 14),
      
      conditionNameLabel.topAnchor.constraint(equalTo: conditionStatusLabel.bottomAnchor, constant: 5),
      conditionNameLabel.leftAnchor.constraint(equalTo: conditionImage.rightAnchor, constant: 4),
      conditionNameLabel.widthAnchor.constraint(equalToConstant: 100),
      conditionNameLabel.heightAnchor.constraint(equalToConstant: 14)
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
      conditionNameLabel.text = "Вероятность осадков"
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

