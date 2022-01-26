//
//  UIView + Ext.swift
//  MyApp
//
//  Created by Dmitry on 21.01.2022.
//

import UIKit

extension UIView {
  
  func addBlurToView() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
    blurredEffectView.frame = frame
    blurredEffectView.alpha = 0.8
    blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //self.addSubview(blurredEffectView)
    self.insertSubview(blurredEffectView, at:0)
  }
}
