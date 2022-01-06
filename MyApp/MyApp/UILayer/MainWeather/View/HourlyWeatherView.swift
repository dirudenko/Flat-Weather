//
//  HourlyWeatherView.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class HourlyWeatherView: UIView {
  
  private(set) lazy var collectionView: UICollectionView = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: adapted(dimensionSize: 16, to: .width), bottom: 0, right: 0)
    layout.itemSize = CGSize(width: adapted(dimensionSize: 72, to: .width), height: adapted(dimensionSize: 104, to: .height))
    layout.scrollDirection = .horizontal
    let frame = CGRect(x: adapted(dimensionSize: 0, to: .width), y: adapted(dimensionSize: 36, to: .height), width: adapted(dimensionSize: 390, to: .width), height: adapted(dimensionSize: 104, to: .height))
    let myCollectionView: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    myCollectionView.isScrollEnabled = true
    myCollectionView.backgroundColor = UIColor(named: "backgroundColor")
    myCollectionView.dataSource = self
    myCollectionView.delegate = self
    myCollectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
    return myCollectionView
  }()
  
  private(set) var dateLabel = TitleLabel(textAlignment: .center)
  let loadingVC = LoadingView()
  
  private var hourlyWeather: [Current]?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupFonts()
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private functions
  private func setupFonts() {
    dateLabel.font = AppFont.bold(size: 14)
  }
  
  private func setupLayouts() {
    addSubview(loadingVC)
    addSubview(dateLabel)
    addSubview(collectionView)
    bringSubviewToFront(loadingVC)
  }
  
  private func addConstraints() {
    
    loadingVC.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      
      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      dateLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 131, to: .width)),
      dateLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height)),
      
      loadingVC.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      loadingVC.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  
  func setHourlyWeatherModel(with data: [Current]?) {
    self.hourlyWeather = data
  }
}
// MARK: - UIView delegates
extension HourlyWeatherView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let hourly = hourlyWeather else { return 0 }
    return hourly.isEmpty ? 0 : 24
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell, let model = hourlyWeather?[indexPath.row]
            
    else { return UICollectionViewCell() }
    
    cell.configure(with: model, index: indexPath.row)
    
    return cell
  }
}
