//
//  WeeklyTableViewCell.swift
//  MyApp
//
//  Created by Dmitry on 29.12.2021.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {
  
    private(set) var conditionImage = MainImage(frame: .zero)
    private(set) var dayLabel = DescriptionLabel()
    private(set) var temperatureLabel = DescriptionLabel()
    private(set) var rainLabel = DescriptionLabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupLayouts()
      setupFonts()
      addConstraints()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
      
    private func setupLayouts() {
      backgroundColor = UIColor(named: "backgroundColor")
      addSubview(conditionImage)
      addSubview(temperatureLabel)
      addSubview(dayLabel)
      addSubview(rainLabel)
    }
    
    private func setupFonts() {
      temperatureLabel.font = AppFont.regular(size: 12)
      dayLabel.font = AppFont.regular(size: 16)
      rainLabel.font = AppFont.regular(size: 12)
      
      //temperatureLabel.textColor = .systemGray
      //rainLabel.textColor = .black
      //dayLabel.textColor = .black
    }
    
    
    private func addConstraints() {
      
      var imageSize: CGFloat {
        adapted(dimensionSize: 24, to: .height)
      }
      
      NSLayoutConstraint.activate([
        
        dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 15, to: .height)),
        dayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 24, to: .width)),
        //dayLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 80, to: .width)),
       // dayLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
       // nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: adapted(dimensionSize: 42, to: .height)),
        
        conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 12, to: .height)),
        conditionImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 155, to: .width)),
        //conditionImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: adapted(dimensionSize: 32, to: .height)),
       // conditionImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: adapted(dimensionSize: 31, to: .width)),
        conditionImage.widthAnchor.constraint(equalToConstant: imageSize),
        conditionImage.heightAnchor.constraint(equalToConstant: imageSize),
        
        temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 17, to: .height)),
        temperatureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 302, to: .width)),
        temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: adapted(dimensionSize: 24, to: .height)),
        temperatureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
       // temperatureLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height)),
        
        rainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 17, to: .height)),
        rainLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 187, to: .width)),
       // descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: adapted(dimensionSize: 16, to: .width)),
        rainLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 62, to: .width)),
        rainLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height))
      ])
    }
    
    func configure(with model: Daily) {
     

      var imageName =  IconHadler.iconDictionary.keyedValue(key: model.weather.first?.id ?? 0)
      if ((imageName?.contains(".fill")) != nil) {
        let newImageName = imageName?.replacingOccurrences(of: ".fill", with: "")
        imageName = newImageName
      }
      conditionImage.image = UIImage(systemName: imageName ?? "thermometer.sun")?.withTintColor(.white, renderingMode: .alwaysOriginal)
  
      temperatureLabel.text = "\(Int(model.temp.night))°/\(Int(model.temp.day))°"
      rainLabel.text = "\(model.rain ??  0)"
    
        let date = Date(timeIntervalSince1970: TimeInterval(model.dt)).dateDayFormatter()
        dayLabel.text = "\(date)"
      
    }
  }
