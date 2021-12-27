//
//  MainWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

protocol HeaderButtonsProtocol: AnyObject {
  func plusButtonTapped()
}

class HeaderWeatherView: UIView {
  
  // let imageSize: CGFloat = 240
  var delegate: HeaderButtonsProtocol?

  
  
  private(set) lazy var collectionView: UICollectionView = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: adapted(dimensionSize: 17, to: .height), left: adapted(dimensionSize: 22, to: .width), bottom: adapted(dimensionSize: 17, to: .height), right: adapted(dimensionSize: 22, to: .width))
    layout.itemSize = CGSize(width: adapted(dimensionSize: 122, to: .width), height: adapted(dimensionSize: 32, to: .height))
    let frame = CGRect(x: adapted(dimensionSize: 16, to: .width), y: adapted(dimensionSize: 444, to: .height), width: adapted(dimensionSize: 326, to: .width), height: adapted(dimensionSize: 105, to: .height))
    let myCollectionView: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    myCollectionView.isScrollEnabled = false
    myCollectionView.backgroundColor = UIColor(named: "backgroundColor")
    return myCollectionView
  }()
  
  private(set) var weatherImage = MainImage(frame: .zero)
//  UIImageView = {
//    let imageView = UIImageView()
//    imageView.contentMode = .scaleAspectFit
//    imageView.layer.masksToBounds = true
//    imageView.translatesAutoresizingMaskIntoConstraints = false
//    return imageView
//  }()
  
  private(set) var dateLabel = TitleLabel(textAlignment: .center)
  //  : UILabel = {
  //    let label = UILabel()
  //    label.font = .systemFont(ofSize: 19, weight: .semibold)
  //    label.adjustsFontSizeToFitWidth = true
  //    label.textColor = .white
  //    label.textAlignment = .center
  //    label.translatesAutoresizingMaskIntoConstraints = false
  //    return label
  //  }()
  
  private(set) var cityNameLabel = TitleLabel(textAlignment: .center)
  //  : UILabel = {
  //    let label = UILabel()
  //    label.font = .systemFont(ofSize: 20, weight: .semibold)
  //    label.adjustsFontSizeToFitWidth = true
  //    label.textColor = .white
  //    label.textAlignment = .center
  //    label.numberOfLines = 0
  //    label.translatesAutoresizingMaskIntoConstraints = false
  //    return label
  //  }()
  
  private(set) var temperatureLabel = TitleLabel(textAlignment: .center)
  //  : UILabel = {
  //    let label = UILabel()
  //    label.font = .systemFont(ofSize: 86, weight: .bold)
  //    label.textColor = .white
  //    label.textAlignment = .center
  //    label.adjustsFontSizeToFitWidth = true
  //    label.translatesAutoresizingMaskIntoConstraints = false
  //    return label
  //  }()
  
  private(set) var conditionLabel = TitleLabel(textAlignment: .center)
  //  : UILabel = {
  //    let label = UILabel()
  //    label.font = .systemFont(ofSize: 19, weight: .bold)
  //    label.textColor = .white
  //    label.textAlignment = .center
  //    label.adjustsFontSizeToFitWidth = true
  //    label.translatesAutoresizingMaskIntoConstraints = false
  //    return label
  //  }()
  
  private(set) var addButton = Button(backgroundColor: UIColor(named: "backgroundColor")!, systemImage: "plus")
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor(named: "backgroundColor")
    setupLayouts()
    addConstraints()
    setupFonts()
    
    addButton.addTarget(self, action: #selector(didTapAdd), for: .touchDown)
  }
  
  private func setupLayouts() {
    addSubview(weatherImage)
    addSubview(dateLabel)
    addSubview(cityNameLabel)
    addSubview(temperatureLabel)
    addSubview(conditionLabel)
    addSubview(collectionView)
    addSubview(addButton)
  }
  
  private func setupFonts() {
    dateLabel.font = AppFont.regular(size: 19)
    cityNameLabel.font = AppFont.bold(size: 20)
    temperatureLabel.font = AppFont.bold(size: 50)
    conditionLabel.font =  AppFont.regular(size: 19)
  }
  
  @objc func didTapAdd() {
    delegate?.plusButtonTapped()
  }
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(2.0)
    context?.setStrokeColor(UIColor.white.cgColor)
    context?.move(to: CGPoint(x:adapted(dimensionSize: 16, to: .width), y: adapted(dimensionSize: 444, to: .height)))
    context?.addLine(to: CGPoint(x: adapted(dimensionSize: 342, to: .width) , y: adapted(dimensionSize: 444, to: .height)))
    context?.strokePath()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    
    var imageSize: CGFloat {
      adapted(dimensionSize: 240, to: .height)
    }
    
    NSLayoutConstraint.activate([
      
      addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      addButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      addButton.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .width)),
      addButton.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .height)),
      
      
      cityNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      cityNameLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -60, to: .width)),
      cityNameLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 120, to: .width)),
      cityNameLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .height)),
      
      weatherImage.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 48, to: .height)),
      weatherImage.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -imageSize / 2),
      weatherImage.widthAnchor.constraint(equalToConstant: imageSize),
      weatherImage.heightAnchor.constraint(equalToConstant: imageSize),
      
      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 288, to: .height)),
      dateLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -(133/2), to: .width)),
      //dateLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 133, to: .width)),
      dateLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
      
      temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 323, to: .height)),
      temperatureLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -(97/2), to: .width)),
      temperatureLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 97, to: .width)),
      temperatureLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 88, to: .height)),
      
      conditionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 409, to: .height)),
      conditionLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -(83/2), to: .width)),
     // conditionLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 83, to: .width)),
      conditionLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height))
      
    ])
  }
  
  func configure(with model: CurrentWeather) {
    
    let date = Date(timeIntervalSince1970: TimeInterval(model.dt)).dateFormatter()
    dateLabel.text = "\(date)".capitalizedFirstLetter
    
    cityNameLabel.text = model.name
    
    conditionLabel.text = model.weather.first?.weatherDescription.capitalizedFirstLetter
    
    let config =  UIImage.SymbolConfiguration.preferringMulticolor()
    let imageName =  IconHadler.iconDictionary.keyedValue(key: model.weather.first?.id ?? 0)
    weatherImage.image = UIImage(systemName: imageName ?? "thermometer.sun.fill", withConfiguration: config)
    
    temperatureLabel.text = "\(Int(model.main.temp))°"
  }
}


