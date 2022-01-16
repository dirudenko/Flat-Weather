//
//  CurrentWeatherCollectionView.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import UIKit

class CurrentWeatherCollectionView: UICollectionView {
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  init(cellType: CollectionViewCellCellTypes) {
    switch cellType {
    case .HourlyCollectionViewCell:
      let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
      layout.sectionInset = UIEdgeInsets(top: 0, left: adapted(dimensionSize: 16, to: .width), bottom: 0, right: 0)
      layout.itemSize = CGSize(width: adapted(dimensionSize: 72, to: .width), height: adapted(dimensionSize: 104, to: .height))
      layout.scrollDirection = .horizontal
      let frame = CGRect(x: adapted(dimensionSize: 0, to: .width), y: adapted(dimensionSize: 36, to: .height), width: adapted(dimensionSize: 390, to: .width), height: adapted(dimensionSize: 104, to: .height))
      super.init(frame: frame, collectionViewLayout: layout)
      configureForHourlyCollectionViewCell()
      
    case .WeatherCollectionViewCell:
      let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
      layout.sectionInset = UIEdgeInsets(top: adapted(dimensionSize: 17, to: .height), left: adapted(dimensionSize: 22, to: .width), bottom: adapted(dimensionSize: 17, to: .height), right: adapted(dimensionSize: 22, to: .width))
      layout.itemSize = CGSize(width: adapted(dimensionSize: 122, to: .width), height: adapted(dimensionSize: 32, to: .height))
      super.init(frame: .zero, collectionViewLayout: layout)
      register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
      configureForWeatherCollectionViewCell()
    }
    
  }
  

  private func configureForWeatherCollectionViewCell() {
    isScrollEnabled = false
    translatesAutoresizingMaskIntoConstraints = false
    register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
    backgroundColor = UIColor(named: "backgroundColor")

  }
  
  private func configureForHourlyCollectionViewCell() {
    isScrollEnabled = true
    translatesAutoresizingMaskIntoConstraints = false
    register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
    backgroundColor = UIColor(named: "backgroundColor")

  }
  

  
}
