//
//  HourlyCollectionViewCell.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
  // MARK: - Private types
  private(set) var conditionImage = MainImage(frame: .zero)
  private(set) var timeLabel = DescriptionLabel()
  private(set) var temperatureLabel = DescriptionLabel()
  private(set) var popLabel = DescriptionLabel()
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
  // MARK: - Private functions
  private func setupLayouts() {
    backgroundColor = UIColor.clear
    addSubview(conditionImage)
    addSubview(temperatureLabel)
    addSubview(timeLabel)
    addSubview(popLabel)
    temperatureLabel.textAlignment = .center
  }
  
  private func setupFonts() {
    temperatureLabel.font = AppFont.regular(size: 19)
    timeLabel.font = AppFont.regular(size: 14)
    popLabel.font = AppFont.regular(size: 14)
  }
  
  
  private func addConstraints() {

    
    NSLayoutConstraint.activate([
      
      timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 8, to: .height)),
      timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 18, to: .width)),
      timeLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 40, to: .width)),
      timeLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
      
      conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 36, to: .height)),
      conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 24, to: .width)),
      conditionImage.widthAnchor.constraint(equalToConstant: Constants.Design.imageCellSize - 12),
      conditionImage.heightAnchor.constraint(equalToConstant: Constants.Design.imageCellSize - 12),
      
      temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 64, to: .height)),
      temperatureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 14, to: .width)),
      temperatureLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 45, to: .width)),
      temperatureLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height)),
      
      popLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 82, to: .height)),
      popLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 12, to: .width)),
      popLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 50, to: .width)),
      popLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 15, to: .height))
    ])
  }
  // MARK: - Public functions
  func configure(with model: [Hourly], index: Int) {
    let modelElement = model[index]
    let pop = modelElement.rain
    popLabel.text = "\(pop)% pop"
    
    var imageName =  IconHadler.id.keyedValue(key: modelElement.iconId )
    if ((imageName?.contains(".fill")) != nil) {
      let newImageName = imageName?.replacingOccurrences(of: ".fill", with: "")
      imageName = newImageName
    }
    conditionImage.image = UIImage(systemName: imageName ?? "thermometer.sun")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    
    temperatureLabel.text = "\(Int(modelElement.feelsLike))°/\(Int(modelElement.temp))°"
    if index == 0 {
      timeLabel.text = "Now"
    } else {
      let date = Date(timeIntervalSince1970: TimeInterval(modelElement.date)).dateHourFormatter()
      timeLabel.text = "\(date)"
    }
  }
}

