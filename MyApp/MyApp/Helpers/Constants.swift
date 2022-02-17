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

    static let buttonSize: CGFloat = 44
    static let verticalViewPadding = adapted(dimensionSize: 16, to: .height)
    static let horizontalViewPadding = adapted(dimensionSize: 16, to: .width)
    static let imageSizeBig: CGFloat = adapted(dimensionSize: 240, to: .height)
    static let imageSizeSmall: CGFloat = adapted(dimensionSize: 160, to: .height)
    static let imageCellSize: CGFloat = adapted(dimensionSize: 32, to: .height)
    static let viewHeight: CGFloat = adapted(dimensionSize: 766, to: .height)
    static let cornerRadius: CGFloat = adapted(dimensionSize: 30, to: .height)
  }

  struct Fonts {
    static let regular = AppFont.regular(size: 16)
    static let regularBold = AppFont.bold(size: 16)
    static let bigBold = AppFont.bold(size: 72)
    static let small = AppFont.regular(size: 12)
  }

  struct Network {
    static let weatherAPIKey = "4151621f5318e81115ce7581adb25359"
   // static let weatherAPIKey = Bundle.main.object(forInfoDictionaryKey: "API_Key") as? String
    static let privacyURL = "https://www.app-privacy-policy.com/live.php?token=wqkLZSOqXNE0E3haGqd6kDn4xPCrqkxC"
  }
}
