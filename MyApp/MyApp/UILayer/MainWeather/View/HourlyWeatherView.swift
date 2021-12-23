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
    return myCollectionView
  }()
  
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
  
  
  private func setupFonts() {
    dateLabel.font = AppFont.bold(size: 14)
    
  }
  
  private func setupLayouts() {
    addSubview(dateLabel)
    addSubview(collectionView)
  }
  
  private func addConstraints() {
    
    NSLayoutConstraint.activate([
      
      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      dateLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 131, to: .width)),
      dateLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height))
      
    ])
    
  }
}
