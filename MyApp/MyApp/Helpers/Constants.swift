//
//  File.swift
//  MyApp
//
//  Created by Dmitry on 21.01.2022.
//

import UIKit

struct Constants {
  
  struct Design {
  static var gradient: CAGradientLayer {
      let gradient = CAGradientLayer()
      gradient.type = .axial
      gradient.colors = [
          UIColor(named: "topColor")!.cgColor,
          UIColor(named: "middleColor")!.cgColor,
          UIColor(named: "bottomColor")!.cgColor
      ]
      gradient.locations = [0, 0.25, 1]
      return gradient
  }
  }
  
  struct Network {
    
  }
}
