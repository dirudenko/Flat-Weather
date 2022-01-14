//
//  AnimationView.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

class AnimationView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    animateLogo()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
  
  
  func animateLogo() {
     bringSubviewToFront(self)
      
//      CATransaction.setCompletionBlock{ [weak self] in
//        UIView.transition(from: self!.animationView,
//                          to: self!.loginInterface,
//                          duration: 1,
//                          options: [.transitionFlipFromBottom],
//                          completion: nil)
//      }
      
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = createBezierPath().cgPath
      shapeLayer.strokeColor = UIColor.systemBlue.cgColor
      shapeLayer.fillColor = UIColor.white.cgColor
      shapeLayer.lineWidth = 3.0
      layer.addSublayer(shapeLayer)
      let circleLayer = CAShapeLayer()
      circleLayer.backgroundColor = UIColor.black.cgColor
      circleLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
      circleLayer.cornerRadius = 5

      let followPathAnimation = CAKeyframeAnimation(keyPath: "position")
      followPathAnimation.path = createBezierPath().cgPath
      followPathAnimation.calculationMode = CAAnimationCalculationMode.cubicPaced
      followPathAnimation.speed = 0.1
      followPathAnimation.repeatCount = Float(Int.max)
      circleLayer.add(followPathAnimation, forKey: nil)
      layer.addSublayer(circleLayer)
    }

  func createBezierPath() -> UIBezierPath {
      let path = UIBezierPath()
      path.move(to: CGPoint(x: 15, y: 85))
      path.addLine(to: CGPoint(x: 85, y: 85))
      path.addArc(withCenter: CGPoint(x: 85, y: 75),
                  radius: 10,
                  startAngle: 45 ,
                  endAngle: 180,
                  clockwise: false)
      path.addArc(withCenter: CGPoint(x: 68, y: 60),
                  radius: 13,
                  startAngle: 0,
                  endAngle: 110,
                  clockwise: false)
      path.addArc(withCenter: CGPoint(x: 35, y: 55),
                  radius: 20,
                  startAngle: 0,
                  endAngle: 280,
                  clockwise: false)
      path.addArc(withCenter: CGPoint(x: 15, y: 70),
                  radius: 15,
                  startAngle: CGFloat(80) ,
                  endAngle: CGFloat(310),
                  clockwise: false)
      path.close()
      return path
    }

}
