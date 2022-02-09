//
//  PrimaryLabel.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//

import UIKit

class DescriptionLabel: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(maxWidth: CGFloat) {
    super.init(frame: .zero)
    frame.size.width = maxWidth
    configure()
  }

  private func configure() {
    textColor                   = .white
    adjustsFontSizeToFitWidth   = true
    minimumScaleFactor          = 0.50
    // numberOfLines = 0
    lineBreakMode               = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
    // textAlignment =            .center
    // sizeToFit()

    // lineBreakMode = .byWordWrapping
  }
}
