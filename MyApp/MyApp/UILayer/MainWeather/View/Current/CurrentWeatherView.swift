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

protocol AlertProtocol: AnyObject {
  func showAlert(text: String)
}

final class CurrentWeatherView: UIView {
  // MARK: - Private types
  private let collectionView = CurrentWeatherCollectionView(cellType: .weatherCollectionViewCell)
  private let weatherImage = MainImage(frame: .zero)
  private let dateLabel = DescriptionLabel()
  private let cityNameLabel = TitleLabel(textAlignment: .center)
  private let temperatureLabel = TitleLabel(textAlignment: .center)
  private let conditionLabel = DescriptionLabel()
  private let loadingVC = LoadingView()
  private let addButton = Button(systemImage: "plus")
  private let settingsButton = Button(systemImage: "line.3.horizontal")
  private let gradient = Constants.Design.gradient
  // MARK: - Private variables
  private var collectionViewTopSmall: NSLayoutConstraint?
  private var collectionViewTopBig: NSLayoutConstraint?

  private var weatherImageTop: NSLayoutConstraint?
  private var weatherImageLeftBig: NSLayoutConstraint?
  private var weatherImageLeftSmall: NSLayoutConstraint?
  private var weatherImageSizeSmall: NSLayoutConstraint?
  private var weatherImageSizeBig: NSLayoutConstraint?
  private var weatherImageHeightSmall: NSLayoutConstraint?
  private var weatherImageHeightBig: NSLayoutConstraint?

  private var dateLabelTopSmall: NSLayoutConstraint?
  private var dateLabelTopBig: NSLayoutConstraint?
  private var dateLabelLeftBig: NSLayoutConstraint?
  private var dateLabelLeftSmall: NSLayoutConstraint?

  private var temperatureLabelTopSmall: NSLayoutConstraint?
  private var temperatureLabelTopBig: NSLayoutConstraint?
  private var temperatureLabelLeftBig: NSLayoutConstraint?
  private var temperatureLabelLeftSmall: NSLayoutConstraint?

  private var conditionLabelTopSmall: NSLayoutConstraint?
  private var conditionLabelTopBig: NSLayoutConstraint?
  private var conditionLabelLeftBig: NSLayoutConstraint?
  private var conditionLabelLeftSmall: NSLayoutConstraint?

  // MARK: - Public variables
  var viewData: MainViewData = .initial {
    didSet {
      setNeedsLayout()
      collectionView.reloadData()
    }
  }

  private var currentWeather: MainInfo?
  weak var alertDelegate: AlertProtocol?
  weak var delegate: HeaderButtonsProtocol?
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupView()
    setupConstraints()
    setupFonts()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }

  /// Data Driven состояние для View
  override func layoutSubviews() {
    super.layoutSubviews()
    gradient.frame = self.bounds
    switch viewData {
    case .initial:
      break
    case .fetching(let model):
      currentWeather = model
      configure(with: model)
      loadingVC.makeInvisible()
    case .loading:
      loadingVC.makeVisible()
    case .success(let model):
      loadingVC.makeInvisible()
      currentWeather = model
      configure(with: model)
    case .failure(let error):
      alertDelegate?.showAlert(text: error)
    
    }
  }
  // MARK: - Private functions
  private func setupLayouts() {
    addSubview(weatherImage)
    addSubview(dateLabel)
    addSubview(cityNameLabel)
    addSubview(temperatureLabel)
    addSubview(conditionLabel)
    addSubview(collectionView)
    addSubview(addButton)
    addSubview(loadingVC)
    addSubview(settingsButton)
    bringSubviewToFront(loadingVC)
    layer.insertSublayer(gradient, at: 0)
    layer.cornerRadius = Constants.Design.cornerRadius
    layer.masksToBounds = true
    dateLabel.textAlignment = .center
    temperatureLabel.accessibilityIdentifier = "topTemperature"
  }

  private func setupView() {
    addButton.addTarget(self, action: #selector(didTapAdd), for: .touchDown)
    settingsButton.addTarget(self, action: #selector(didTapOptions), for: .touchDown)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    weatherImage.isUserInteractionEnabled = true
    weatherImage.addGestureRecognizer(tapGestureRecognizer)
    collectionView.delegate = self
    collectionView.dataSource = self
    backgroundColor = UIColor(named: "bottomColor")
    addButton.accessibilityIdentifier = "pushSearch"
    settingsButton.accessibilityIdentifier = "pustSettings"
  }

  private func setupFonts() {
    dateLabel.font = Constants.Fonts.regular
    cityNameLabel.font = Constants.Fonts.regularBold
    temperatureLabel.font = Constants.Fonts.bigBold
    conditionLabel.font =  Constants.Fonts.regular
    conditionLabel.textAlignment = .center
  }

  @objc private func didTapOptions() {
    delegate?.optionsButtonTapped()
  }

  @objc private func didTapAdd() {
    delegate?.plusButtonTapped()
  }

  @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    //  let tappedImage = tapGestureRecognizer.view as! UIImageView
    // TODO: Анимация перехода на экран с изображением погоды
      print("IMAGE TAPPED")
  }

  private func configure(with model: MainInfo?) {
    guard let model = model ,
          let topBar = model.topWeather else { return }
    cityNameLabel.text = model.name

    let date = Date(timeIntervalSince1970: TimeInterval(topBar.date)).dateFormatter()
    dateLabel.text = "\(date)".capitalizedFirstLetter

    conditionLabel.text = topBar.desc?.capitalizedFirstLetter
    let imageName =  IconHadler.id.keyedValue(key: topBar.iconId)

    if #available(iOS 15.0, *) {
      let config =  UIImage.SymbolConfiguration.preferringMulticolor()
      weatherImage.image = UIImage(systemName: imageName ?? "thermometer.sun.fill", withConfiguration: config)

    } else {
      weatherImage.image = UIImage(systemName: imageName ?? "thermometer.sun.fill")
    }
    temperatureLabel.text = "\(Int(topBar.temperature))° "
  }

}
// MARK: - UIView delegates
extension CurrentWeatherView: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentWeather != nil ? 4 : 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath)
            as? WeatherCollectionViewCell,
          let model = currentWeather
    else { return UICollectionViewCell() }
    cell.configure(with: model, index: indexPath.row)
    return cell
  }
}

// MARK: - Constraints
extension CurrentWeatherView {

//  override func draw(_ rect: CGRect) {
//    let contextBig = UIGraphicsGetCurrentContext()
//    contextBig?.setLineWidth(2.0)
//    contextBig?.setStrokeColor(UIColor.white.cgColor)
//    contextBig?.move(to: CGPoint(x:adapted(dimensionSize: 16, to: .width), y: topPadding))
//    contextBig?.addLine(to: CGPoint(x: adapted(dimensionSize: 342, to: .width) , y: topPadding))
//    contextBig?.strokePath()
//  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([

      addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.Design.verticalViewPadding),
      addButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.Design.horizontalViewPadding),
      addButton.widthAnchor.constraint(equalToConstant: Constants.Design.buttonSize),
      addButton.heightAnchor.constraint(equalToConstant: Constants.Design.buttonSize),

      settingsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.Design.verticalViewPadding),
      settingsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.Design.horizontalViewPadding),
      settingsButton.widthAnchor.constraint(equalToConstant: Constants.Design.buttonSize),
      settingsButton.heightAnchor.constraint(equalToConstant: Constants.Design.buttonSize),

      cityNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.Design.verticalViewPadding),
      cityNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      cityNameLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 32, to: .height)),

      weatherImage.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 48, to: .height)),
      conditionLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -Constants.Design.horizontalViewPadding),
      dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.Design.horizontalViewPadding),

      collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.Design.horizontalViewPadding),
      collectionView.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 326, to: .width)),
      collectionView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 105, to: .height)),

      loadingVC.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      loadingVC.centerYAnchor.constraint(equalTo: self.centerYAnchor)

    ])

    collectionViewTopBig = collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 444, to: .height))
    collectionViewTopBig?.isActive = true
    collectionViewTopSmall = collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 232, to: .height))

    weatherImageLeftBig = weatherImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    weatherImageLeftBig?.isActive = true
    weatherImageLeftSmall = weatherImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width))
    weatherImageSizeBig = weatherImage.widthAnchor.constraint(equalToConstant: Constants.Design.imageSizeBig)
    weatherImageSizeBig?.isActive = true
    weatherImageSizeSmall = weatherImage.widthAnchor.constraint(equalToConstant: Constants.Design.imageSizeSmall)
    weatherImageHeightBig = weatherImage.heightAnchor.constraint(equalToConstant: Constants.Design.imageSizeBig)
    weatherImageHeightBig?.isActive = true
    weatherImageHeightSmall = weatherImage.heightAnchor.constraint(equalToConstant: Constants.Design.imageSizeSmall)

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

  func changeConstraints(isPressed: Bool) {
    if isPressed {

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
}
