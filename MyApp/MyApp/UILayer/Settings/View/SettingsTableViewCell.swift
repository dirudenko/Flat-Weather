//
//  SettingsTableViewCell.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  
    private(set) var nameLabel = DescriptionLabel()
    private(set) var unitLabel = DescriptionLabel()
    
    
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
      addSubview(nameLabel)
      addSubview(unitLabel)
    }
    
    private func setupFonts() {
      nameLabel.font = AppFont.regular(size: 16)
      unitLabel.font = AppFont.regular(size: 16)
    }
    
    
    private func addConstraints() {
      
  
      
      NSLayoutConstraint.activate([
        
       
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 6, to: .height)),
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
        
   
        
        unitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 6, to: .height)),
        unitLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 318, to: .width)),
        
      ])
    }
    
//    func configure(with model: Daily) {
//
//
//      var imageName =  IconHadler.iconDictionary.keyedValue(key: model.weather.first?.id ?? 0)
//      if ((imageName?.contains(".fill")) != nil) {
//        let newImageName = imageName?.replacingOccurrences(of: ".fill", with: "")
//        imageName = newImageName
//      }
//      conditionImage.image = UIImage(systemName: imageName ?? "thermometer.sun")?.withTintColor(.white, renderingMode: .alwaysOriginal)
//
//      temperatureLabel.text = "\(Int(model.temp.night))°/\(Int(model.temp.day))°"
//      rainLabel.text = "\(model.rain ??  0)"
//
//        let date = Date(timeIntervalSince1970: TimeInterval(model.dt)).dateDayFormatter()
//        dayLabel.text = "\(date)"
//
//    }
  }
