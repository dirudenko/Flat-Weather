//
//  MainWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class HeaderWeatherView: UIView {
  
  let imageSize: CGFloat = 240
  
  private(set) lazy var collectionView: UICollectionView = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 17, left: 22, bottom: 17, right: 22)
    layout.itemSize = CGSize(width: 122, height: 32)
    
    let frame = CGRect(x: 16, y: 444, width: 326, height: 105)
    let myCollectionView: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    myCollectionView.dataSource = self
    myCollectionView.delegate = self
    myCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
    myCollectionView.backgroundColor = UIColor(named: "backgroundColor")
    return myCollectionView
  }()
  
  private(set) lazy var weatherImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private(set) lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 19, weight: .semibold)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var citiNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    label.adjustsFontSizeToFitWidth = true
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var temperatureLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 86, weight: .bold)
    label.textColor = .white
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var conditionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 19, weight: .bold)
    label.textColor = .white
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var separator = UIColor.separator
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(weatherImage)
    addSubview(dateLabel)
    addSubview(citiNameLabel)
    addSubview(temperatureLabel)
    addSubview(conditionLabel)
    addSubview(collectionView)
    backgroundColor = UIColor(named: "backgroundColor")
    addConstraints()
  }
  
  override func draw(_ rect: CGRect) {
          let context = UIGraphicsGetCurrentContext()
          context?.setLineWidth(2.0)
          context?.setStrokeColor(UIColor.white.cgColor)
          context?.move(to: CGPoint(x:16, y: 444))
          context?.addLine(to: CGPoint(x: 342 , y: 444))
          context?.strokePath()
      }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    
    NSLayoutConstraint.activate([
      
      citiNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      citiNameLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -30.5),
      citiNameLabel.widthAnchor.constraint(equalToConstant: 61),
      citiNameLabel.heightAnchor.constraint(equalToConstant: 32),
      
      weatherImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 48),
      weatherImage.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -imageSize / 2),
      weatherImage.widthAnchor.constraint(equalToConstant: imageSize),
      weatherImage.heightAnchor.constraint(equalToConstant: imageSize),
      
      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 288),
      dateLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -(133 / 2)),
      dateLabel.widthAnchor.constraint(equalToConstant: 133),
      dateLabel.heightAnchor.constraint(equalToConstant: 19),
      
      temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 323),
      temperatureLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -(97 / 2)),
      temperatureLabel.widthAnchor.constraint(equalToConstant: 97),
      temperatureLabel.heightAnchor.constraint(equalToConstant: 86),
      
      conditionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 409),
      conditionLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -(83 / 2)),
      conditionLabel.widthAnchor.constraint(equalToConstant: 83),
      conditionLabel.heightAnchor.constraint(equalToConstant: 19),
      
      collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 444),
      collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      collectionView.widthAnchor.constraint(equalToConstant: 326),
      collectionView.heightAnchor.constraint(equalToConstant: 105)
      
    ])
  }
}
extension HeaderWeatherView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell else { return UICollectionViewCell() }
    cell.conditionStatusLabel.text = "\(indexPath.row)"
    cell.conditionImage.image = UIImage(systemName: "sun.and.horizon.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    cell.conditionNameLabel.text = "TEST"    
    return cell
  }
  
  
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


