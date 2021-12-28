//
//  MainImage.swift
//  MyApp
//
//  Created by Dmitry on 22.12.2021.
//

import UIKit

class MainImage: UIImageView {
  
  override init(frame: CGRect) {
          super.init(frame: frame)
          configure()
      }
      
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      
      private func configure() {
        contentMode         = .scaleAspectFit
         // clipsToBounds       = true
          translatesAutoresizingMaskIntoConstraints = false
      }
      

}
