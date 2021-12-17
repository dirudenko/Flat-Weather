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
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: 72, height: 104)
    layout.scrollDirection = .horizontal
    let frame = CGRect(x: 0, y: 36, width: 390, height: 104)
    let myCollectionView: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    myCollectionView.isScrollEnabled = true
    myCollectionView.backgroundColor = UIColor(named: "backgroundColor")
    return myCollectionView
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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(dateLabel)
    addSubview(collectionView)
    // backgroundColor = UIColor(named: "backgroundColor")
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    
    NSLayoutConstraint.activate([
      
      dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
      dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      dateLabel.widthAnchor.constraint(equalToConstant: 131),
      dateLabel.heightAnchor.constraint(equalToConstant: 19)
      
    ])
    
  }
}
