//
//  Picker.swift
//  MyApp
//
//  Created by Dmitry on 25.01.2022.
//

import UIKit

class Picker: UIPickerView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(for view: UIView) {
    super.init(frame: .zero)
    configure(view: view)
  }
  
  func configure(view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(self)
    centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    backgroundColor = .white
  }
  
}
