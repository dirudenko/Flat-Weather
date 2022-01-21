//
//  SettingsTableViewCell.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  
    private(set) var nameLabel = DescriptionLabel()
    private(set) var unitLabel = DescriptionLabel()
  
    var unitsType: UnitOptions? {
    didSet {
      nameLabel.text = unitsType?.description
      unitLabel.text = unitsType?.containsType
    }
  }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupLayouts()
      setupFonts()
      addConstraints()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
      
    private func setupLayouts() {
      backgroundColor = .clear
      addSubview(nameLabel)
      addSubview(unitLabel)
    }
    
    private func setupFonts() {
      nameLabel.font = AppFont.regular(size: 16)
      unitLabel.font = AppFont.regular(size: 16)
    }
    
    
    private func addConstraints() {

      NSLayoutConstraint.activate([
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 6, to: .height)),
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
        
        unitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 6, to: .height)),
        unitLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 278, to: .width)),
        
      ])
    }
  }
