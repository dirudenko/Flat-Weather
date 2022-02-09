//
//  BackButton.swift
//  MyApp
//
//  Created by Dmitry on 19.01.2022.
//

import UIKit

class BackButton: UIButton {

  override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  init(backgroundColor: UIColor) {
      super.init(frame: .zero)
      // self.backgroundColor = backgroundColor
      if let image = UIImage(systemName: "arrow.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
      setImage(image, for: .normal)
    }
      configure()
  }

  private func configure() {
      // layer.cornerRadius      = 10
     // setTitleColor(.white, for: .normal)
    //  titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
    imageView?.contentMode = .scaleToFill

   // backgroundColor = .black
      translatesAutoresizingMaskIntoConstraints = false
  }

}
