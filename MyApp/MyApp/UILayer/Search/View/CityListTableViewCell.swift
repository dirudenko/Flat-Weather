//
//  CityListTableViewCell.swift
//  MyApp
//
//  Created by Dmitry on 23.12.2021.
//

import UIKit

class CityListTableViewCell: UITableViewCell {
  
  private(set) var conditionImage = MainImage(frame: .zero)
  private(set) var nameLabel = DescriptionLabel()
  private(set) var temperatureLabel = DescriptionLabel()
  private(set) var descriptionLabel = DescriptionLabel()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layer.cornerRadius = adapted(dimensionSize: 16, to: .height)
    clipsToBounds = true
    setupLayouts()
    setupFonts()
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  private func setupLayouts() {
    addSubview(conditionImage)
    addSubview(temperatureLabel)
    addSubview(nameLabel)
    addSubview(descriptionLabel)
  }
  
  private func setupFonts() {
    temperatureLabel.font = AppFont.regular(size: 12)
    nameLabel.font = AppFont.regular(size: 16)
    descriptionLabel.font = AppFont.regular(size: 12)
    
    temperatureLabel.textColor = .systemGray
    descriptionLabel.textColor = .black
    nameLabel.textColor = .black
  }
  
  
  private func addConstraints() {
    
    var imageSize: CGFloat {
      adapted(dimensionSize: 32, to: .height)
    }
    
    NSLayoutConstraint.activate([
      
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 19, to: .height)),
      nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      nameLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 80, to: .width)),
      nameLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
     // nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: adapted(dimensionSize: 42, to: .height)),
      
      conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 19, to: .height)),
      conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 263, to: .width)),
      //conditionImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: adapted(dimensionSize: 32, to: .height)),
     // conditionImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: adapted(dimensionSize: 31, to: .width)),
      conditionImage.widthAnchor.constraint(equalToConstant: imageSize),
      conditionImage.heightAnchor.constraint(equalToConstant: imageSize),
      
      temperatureLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: adapted(dimensionSize: 4, to: .height)),
      temperatureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 14, to: .width)),
      temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: adapted(dimensionSize: 24, to: .height)),
      temperatureLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 44, to: .width)),
      temperatureLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height)),
      
      descriptionLabel.topAnchor.constraint(equalTo: conditionImage.bottomAnchor, constant: adapted(dimensionSize: 2, to: .height)),
      descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 248, to: .width)),
     // descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      descriptionLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 62, to: .width)),
      descriptionLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height))
    ])
  }
  
  func configure(with model: List) {
    guard let cityModel = model.inList as? Set<MainInfo>,
          let city = cityModel.first?.topWeather else { return }
    descriptionLabel.text = city.desc
    temperatureLabel.text = "\(city.temperature)°"
    nameLabel.text = cityModel.first?.name

    var imageName =  IconHadler.iconDictionary.keyedValue(key: Int(city.iconId))
    if ((imageName?.contains(".fill")) != nil) {
      let newImageName = imageName?.replacingOccurrences(of: ".fill", with: "")
      imageName = newImageName
    }
    conditionImage.image = UIImage(systemName: imageName ?? "thermometer.sun")?.withTintColor(.black, renderingMode: .alwaysOriginal)
//
//    temperatureLabel.text = "\(Int(model.hourly[index].feelsLike))°/\(Int(model.hourly[index].temp))°"
//    if index == 0 {
//      timeLabel.text = "Сейчас"
//    } else {
//      let date = Date(timeIntervalSince1970: TimeInterval(model.hourly[index].dt)).dateHourFormatter()
//      timeLabel.text = "\(date)"
//    }
  }
}
