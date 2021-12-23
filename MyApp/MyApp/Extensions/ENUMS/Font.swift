//
//  Font.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//

import UIKit

enum AppFont {
    static func regular(size: CGFloat) -> UIFont {
        UIFont(name: "Helvetica", size: size.adaptedFontSize)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        UIFont(name: "Helvetica-Bold", size: size.adaptedFontSize)!
    }
  
  static func Oblique(size: CGFloat) -> UIFont {
      UIFont(name: "Helvetica-Oblique", size: size.adaptedFontSize)!
  }
}