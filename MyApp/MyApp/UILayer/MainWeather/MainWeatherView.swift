//
//  MainWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class MainWeatherView: UIView {
  
  let imageSize: CGFloat = 240

  
  private(set) lazy var weatherImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private(set) lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 21, weight: .semibold)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var citiNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 28, weight: .semibold)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var temperatureLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 80, weight: .bold)
    label.textColor = .white
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var conditionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .bold)
    label.textColor = .white
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(weatherImage)
    addSubview(dateLabel)
    addSubview(citiNameLabel)
    addSubview(temperatureLabel)
    addSubview(conditionLabel)
    backgroundColor = UIColor(named: "backgroundColor")

    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addConstraints()
  }
  
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
      
      citiNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      citiNameLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -30.5),
      citiNameLabel.widthAnchor.constraint(equalToConstant: 61),
      citiNameLabel.heightAnchor.constraint(equalToConstant: 32),
      
      weatherImage.topAnchor.constraint(equalTo: citiNameLabel.bottomAnchor, constant: 59),
      weatherImage.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -imageSize / 2),
      weatherImage.widthAnchor.constraint(equalToConstant: imageSize),
      weatherImage.heightAnchor.constraint(equalToConstant: imageSize),
      
      dateLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 10),
      dateLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -(133 / 2)),
      dateLabel.widthAnchor.constraint(equalToConstant: 133),
      dateLabel.heightAnchor.constraint(equalToConstant: 19),
      
      temperatureLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
      temperatureLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -(97 / 2)),
      temperatureLabel.widthAnchor.constraint(equalToConstant: 97),
      temperatureLabel.heightAnchor.constraint(equalToConstant: 86),
      
      conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
      conditionLabel.leftAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -(83 / 2)),
      conditionLabel.widthAnchor.constraint(equalToConstant: 83),
      conditionLabel.heightAnchor.constraint(equalToConstant: 19),
    ])
  }
  
//  func configure(with model: Conversation) {
//    userMessageLabel.text = model.latestMessage.text
//    userNameLabel.text = model.name
//    let path = "images/\(model.otherUserEmail)_profile_picture.png"
//    storageService.downloadURL(for: path) { [weak self] result in
//      switch result {
//      case .success(let url):
//        DispatchQueue.main.async {
//          self?.userImage.sd_setImage(with: url, completed: nil)
//        }
//      case .failure(let error):
//        print("Error to get image \(error)")
//      }
//    }
//  }
//}

}
