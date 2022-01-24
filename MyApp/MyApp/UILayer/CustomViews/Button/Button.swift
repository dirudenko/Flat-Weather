//
//  Button.swift
//  MyApp
//
//  Created by Dmitry on 23.12.2021.
//

import UIKit

class Button: UIButton {
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init( systemImage: String) {
    super.init(frame: .zero)
    if let image = UIImage(systemName: systemImage)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
      setImage(image, for: .normal)
    }
    configure()
  }
  
  private func configure() {
    //layer.cornerRadius      = 10
    // setTitleColor(.white, for: .normal)
    //  titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
    imageView?.contentMode = .scaleToFill
    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
  }
}
