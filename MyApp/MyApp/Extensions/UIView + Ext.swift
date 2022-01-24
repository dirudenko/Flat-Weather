//
//  UIView + Ext.swift
//  MyApp
//
//  Created by Dmitry on 21.01.2022.
//

import UIKit

extension UIView {
  
  func addShadow() {
    backgroundColor = .green
    layer.masksToBounds = false
    layer.shadowOffset = CGSize(width: 10,
                                     height: 10)
    layer.shadowRadius = 5
    layer.shadowOpacity = 0.3
    layer.shadowPath = self.customShadowPath(viewLayer: self.layer,
                                                  shadowHeight: 5).cgPath
    
  }
  
  func customShadowPath(viewLayer layer: CALayer,
                        shadowHeight: CGFloat) -> UIBezierPath {
    let layerX = layer.bounds.origin.x
    let layerY = layer.bounds.origin.y
    let layerWidth = layer.bounds.size.width
    let layerHeight = layer.bounds.size.height
    
    let path = UIBezierPath()
    path.move(to: CGPoint.zero)
    
    path.addLine(to: CGPoint(x: layerX + layerWidth,
                             y: layerY))
    path.addLine(to: CGPoint(x: layerX + layerWidth,
                             y: layerHeight + 20))
    
    path.addCurve(to: CGPoint(x: 0,
                              y: layerHeight),
                  controlPoint1: CGPoint(x: layerX + layerWidth,
                                         y: layerHeight),
                  controlPoint2: CGPoint(x: layerX,
                                         y: layerHeight))
    
    return path
  }
  func dropShadow() {
          layer.masksToBounds = false
          layer.shadowColor = UIColor.black.cgColor
          layer.shadowOpacity = 0.5
          layer.shadowOffset = CGSize(width: -1, height: 1)
          layer.shadowRadius = 1
          layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
          layer.shouldRasterize = true
          layer.rasterizationScale = UIScreen.main.scale
      }
}
