//
//  LoadingViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class LoadingView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    addSpinner()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  
   private func addSpinner() {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.color = .systemGray
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.startAnimating()
    self.addSubview(spinner)
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  
  func makeInvisible() {
    self.isHidden = true
  }
  
  func makeVisible() {
    self.isHidden = false
  }
}
