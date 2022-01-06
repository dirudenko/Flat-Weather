//
//  MainWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

protocol HeaderButtonsProtocol: AnyObject {
  func plusButtonTapped()
  func optionsButtonTapped()
}

class CurrentWeatherView: UIView {

  private(set) lazy var collectionView: UICollectionView = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: adapted(dimensionSize: 17, to: .height), left: adapted(dimensionSize: 22, to: .width), bottom: adapted(dimensionSize: 17, to: .height), right: adapted(dimensionSize: 22, to: .width))
    layout.itemSize = CGSize(width: adapted(dimensionSize: 122, to: .width), height: adapted(dimensionSize: 32, to: .height))
    let myCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    myCollectionView.isScrollEnabled = false
    myCollectionView.translatesAutoresizingMaskIntoConstraints = false
    myCollectionView.dataSource = self
    myCollectionView.delegate = self
    myCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
    myCollectionView.backgroundColor = UIColor(named: "backgroundColor")
    return myCollectionView
  }()
  
  private(set) var collectionViewTopSmall: NSLayoutConstraint?
  private(set) var collectionViewTopBig: NSLayoutConstraint?
  
  private(set) var weatherImage = MainImage(frame: .zero)
  private(set) var weatherImageTop: NSLayoutConstraint?
  private(set) var weatherImageLeftBig: NSLayoutConstraint?
  private(set) var weatherImageLeftSmall: NSLayoutConstraint?
  private(set) var weatherImageSizeSmall: NSLayoutConstraint?
  private(set) var weatherImageSizeBig: NSLayoutConstraint?
  private(set) var weatherImageHeightSmall: NSLayoutConstraint?
  private(set) var weatherImageHeightBig: NSLayoutConstraint?
  
  private(set) var dateLabel = TitleLabel(textAlignment: .center)
  private(set) var dateLabelTopSmall: NSLayoutConstraint?
  private(set) var dateLabelTopBig: NSLayoutConstraint?
  private(set) var dateLabelLeftBig: NSLayoutConstraint?
  private(set) var dateLabelLeftSmall: NSLayoutConstraint?
  
  private(set) var cityNameLabel = TitleLabel(textAlignment: .center)
  
  private(set) var temperatureLabel = TitleLabel(textAlignment: .center)
  private(set) var temperatureLabelTopSmall: NSLayoutConstraint?
  private(set) var temperatureLabelTopBig: NSLayoutConstraint?
  private(set) var temperatureLabelLeftBig: NSLayoutConstraint?
  private(set) var temperatureLabelLeftSmall: NSLayoutConstraint?
  
  private(set) var conditionLabel = DescriptionLabel()
  private(set) var conditionLabelTopSmall: NSLayoutConstraint?
  private(set) var conditionLabelTopBig: NSLayoutConstraint?
  private(set) var conditionLabelLeftBig: NSLayoutConstraint?
  private(set) var conditionLabelLeftSmall: NSLayoutConstraint?
  
  private(set) var addButton = Button(backgroundColor: UIColor(named: "backgroundColor")!, systemImage: "plus")
  private(set) var optionsButton = Button(backgroundColor: UIColor(named: "backgroundColor")!, systemImage: "line.3.horizontal")
  private var topPadding = adapted(dimensionSize: 444, to: .height)

  let loadingVC = LoadingView()
  var delegate: HeaderButtonsProtocol?
  private var currentWeather: MainInfo?

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor(named: "backgroundColor")
    setupLayouts()
    setupConstraints()
    setupFonts()
    addButton.addTarget(self, action: #selector(didTapAdd), for: .touchDown)
    optionsButton.addTarget(self, action: #selector(didTapOptions), for: .touchDown)
  }
  
  private func setupLayouts() {
    addSubview(weatherImage)
    addSubview(dateLabel)
    addSubview(cityNameLabel)
    addSubview(temperatureLabel)
    addSubview(conditionLabel)
    addSubview(collectionView)
    addSubview(addButton)
    addSubview(loadingVC)
    addSubview(optionsButton)
    bringSubviewToFront(loadingVC)
  }
  
  private func setupFonts() {
    dateLabel.font = AppFont.regular(size: 16)
    cityNameLabel.font = AppFont.bold(size: 16)
    temperatureLabel.font = AppFont.bold(size: 72)
    conditionLabel.font =  AppFont.regular(size: 16)
    conditionLabel.textAlignment = .center
  }
  
  @objc func didTapOptions() {
    delegate?.optionsButtonTapped()
  }
  
  @objc func didTapAdd() {
    delegate?.plusButtonTapped()
  }
  
  override func draw(_ rect: CGRect) {
    let contextBig = UIGraphicsGetCurrentContext()
    contextBig?.setLineWidth(2.0)
    contextBig?.setStrokeColor(UIColor.white.cgColor)
    contextBig?.move(to: CGPoint(x:adapted(dimensionSize: 16, to: .width), y: topPadding))
    contextBig?.addLine(to: CGPoint(x: adapted(dimensionSize: 342, to: .width) , y: topPadding))
    contextBig?.strokePath()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    
    let imageSizeBig: CGFloat = adapted(dimensionSize: 240, to: .height)
    let imageSizeSmall: CGFloat = adapted(dimensionSize: 160, to: .height)
    loadingVC.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      
      addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      addButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      addButton.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .width)),
      addButton.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .height)),
      
      optionsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      optionsButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 310, to: .width)),
      optionsButton.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .width)),
      optionsButton.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .height)),
      
      
      cityNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      cityNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
     // cityNameLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 120, to: .width)),
      cityNameLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .height)),
      
      weatherImage.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 48, to: .height)),
      //dateLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
     // temperatureLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 86, to: .height)),
      conditionLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor ,constant: adapted(dimensionSize: -16, to: .width)),
      dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor ,constant: adapted(dimensionSize: -16, to: .width)),
     // temperatureLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor ,constant: adapted(dimensionSize: -16, to: .width)),
      
     
      collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      collectionView.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 326, to: .width)),
      collectionView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 105, to: .height)),
      
      loadingVC.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      loadingVC.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
    ])
    collectionViewTopBig = collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 444, to: .height))
    collectionViewTopBig?.isActive = true
    collectionViewTopSmall = collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 232, to: .height))
    
    weatherImageLeftBig = weatherImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    weatherImageLeftBig?.isActive = true
    weatherImageLeftSmall = weatherImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width))
    weatherImageSizeBig = weatherImage.widthAnchor.constraint(equalToConstant: imageSizeBig)
    weatherImageSizeBig?.isActive = true
    weatherImageSizeSmall = weatherImage.widthAnchor.constraint(equalToConstant: imageSizeSmall)
    weatherImageHeightBig = weatherImage.heightAnchor.constraint(equalToConstant: imageSizeBig)
    weatherImageHeightBig?.isActive = true
    weatherImageHeightSmall = weatherImage.heightAnchor.constraint(equalToConstant: imageSizeSmall)
    
    dateLabelTopBig = dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 288, to: .height))
    dateLabelTopBig?.isActive = true
    dateLabelTopSmall = dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 68, to: .height))
    dateLabelLeftBig = dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    dateLabelLeftBig?.isActive = true
    dateLabelLeftSmall = dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 199, to: .width))
    
    temperatureLabelTopBig = temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 323, to: .height))
    temperatureLabelTopBig?.isActive = true
    temperatureLabelTopSmall = temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 103, to: .height))
    temperatureLabelLeftBig = temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    temperatureLabelLeftBig?.isActive = true
    temperatureLabelLeftSmall = temperatureLabel.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor)
    
    conditionLabelTopBig = conditionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 409, to: .height))
    conditionLabelTopBig?.isActive = true
    conditionLabelTopSmall = conditionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 189, to: .height))
    conditionLabelLeftBig = conditionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    conditionLabelLeftBig?.isActive = true
    conditionLabelLeftSmall = conditionLabel.centerXAnchor.constraint(equalTo: temperatureLabel.centerXAnchor)
  }
  
  
}

extension CurrentWeatherView {
  func changeConstraints(isPressed: Bool) {
    if isPressed {
      
      topPadding = adapted(dimensionSize: 232, to: .height)
      setNeedsDisplay()
      
      weatherImageLeftBig?.isActive = false
      weatherImageLeftSmall?.isActive = true
      weatherImageSizeBig?.isActive = false
      weatherImageSizeSmall?.isActive = true
      weatherImageHeightBig?.isActive = false
      weatherImageHeightSmall?.isActive = true
      
      dateLabelTopBig?.isActive = false
      dateLabelTopSmall?.isActive = true
      dateLabelLeftBig?.isActive = false
      dateLabelLeftSmall?.isActive = true
      
      temperatureLabelTopBig?.isActive = false
      temperatureLabelTopSmall?.isActive = true
      temperatureLabelLeftBig?.isActive = false
      temperatureLabelLeftSmall?.isActive = true
      
      conditionLabelTopBig?.isActive = false
      conditionLabelTopSmall?.isActive = true
      conditionLabelLeftBig?.isActive = false
      conditionLabelLeftSmall?.isActive = true
      
      collectionViewTopBig?.isActive = false
      collectionViewTopSmall?.isActive = true
    
      UIView.animate(withDuration: 0.3) {
        self.layoutIfNeeded()
      }
      
      
    } else {
      
      topPadding = adapted(dimensionSize: 444, to: .height)
      setNeedsDisplay()
      
      weatherImageLeftSmall?.isActive = false
      weatherImageLeftBig?.isActive = true
      weatherImageSizeSmall?.isActive = false
      weatherImageSizeBig?.isActive = true
      weatherImageHeightSmall?.isActive = false
      weatherImageHeightBig?.isActive = true
      
      dateLabelTopSmall?.isActive = false
      dateLabelTopBig?.isActive = true
      dateLabelLeftSmall?.isActive = false
      dateLabelLeftBig?.isActive = true
      
      temperatureLabelTopSmall?.isActive = false
      temperatureLabelTopBig?.isActive = true
      temperatureLabelLeftSmall?.isActive = false
      temperatureLabelLeftBig?.isActive = true
      
      conditionLabelTopSmall?.isActive = false
      conditionLabelTopBig?.isActive = true
      conditionLabelLeftSmall?.isActive = false
      conditionLabelLeftBig?.isActive = true
      
      collectionViewTopSmall?.isActive = false
      collectionViewTopBig?.isActive = true
      
      UIView.animate(withDuration: 0.3) {
        self.layoutIfNeeded()
      }
      
    }
  }
  
  
  func configure(with model: MainInfo) {
    
    cityNameLabel.text = model.name
    guard  let topBar = model.topWeather else { return }
    
    let date = Date(timeIntervalSince1970: TimeInterval(topBar.date)).dateFormatter()
    dateLabel.text = "\(date)".capitalizedFirstLetter
    
    
    conditionLabel.text = topBar.desc
    
    let config =  UIImage.SymbolConfiguration.preferringMulticolor()
    let imageName =  IconHadler.iconDictionary.keyedValue(key: Int(topBar.iconId))
    weatherImage.image = UIImage(systemName: imageName ?? "thermometer.sun.fill", withConfiguration: config)
    
    temperatureLabel.text = "\(Int(topBar.temperature))°"
  }
  
  func setCurrentWeather(_ data: MainInfo?) {
    guard let data = data else { return }
    self.currentWeather = data
  }
}

extension CurrentWeatherView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentWeather != nil ? 4 : 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell,
          let model = currentWeather
    else { return UICollectionViewCell() }
    cell.configure(with: model, index: indexPath.row)
    return cell
  }
}

