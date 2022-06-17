//
//  WeeklyTableViewCell.swift
//  MyApp
//
//  Created by Dmitry on 29.12.2021.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {
  // MARK: - Private types
    private(set) var conditionImage = MainImage(frame: .zero)
    private(set) var dayLabel = DescriptionLabel()
    private(set) var temperatureLabel = DescriptionLabel()
    private(set) var rainLabel = DescriptionLabel()
  // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
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
      addSubview(dayLabel)
      addSubview(rainLabel)
    }

    private func setupFonts() {
      temperatureLabel.font = AppFont.regular(size: 12)
      dayLabel.font = AppFont.regular(size: 16)
      rainLabel.font = AppFont.regular(size: 12)
    }

    private func addConstraints() {
      var imageSize: CGFloat {
        adapted(dimensionSize: 24, to: .height)
      }

      NSLayoutConstraint.activate([

        dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 15, to: .height)),
        dayLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 24, to: .width)),

        conditionImage.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 12, to: .height)),
        conditionImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 155, to: .width)),
        conditionImage.widthAnchor.constraint(equalToConstant: imageSize),
        conditionImage.heightAnchor.constraint(equalToConstant: imageSize),

        temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 17, to: .height)),
        temperatureLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 302, to: .width)),
       // temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: adapted(dimensionSize: 24, to: .height)),
        temperatureLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),

        rainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 17, to: .height)),
        rainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 187, to: .width))
       // rainLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 62, to: .width)),
       // rainLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 14, to: .height))
      ])
    }
  // MARK: - Public functions
    func configure(with model: Weekly) {
      var imageName =  IconHadler.id.keyedValue(key: model.iconId )
      if (imageName?.contains(".fill")) != nil {
        let newImageName = imageName?.replacingOccurrences(of: ".fill", with: "")
        imageName = newImageName
      }
      conditionImage.image = UIImage(systemName: imageName ?? "thermometer.sun")?.withTintColor(.white, renderingMode: .alwaysOriginal)

      temperatureLabel.text = "\(Int(model.tempNight))°/\(Int(model.tempDay))°"
      rainLabel.text = "\(model.pop)%"

        let date = Date(timeIntervalSince1970: TimeInterval(model.date)).dateDayFormatter()
      dayLabel.text = "\(date)".capitalizedFirstLetter

    }
  }
