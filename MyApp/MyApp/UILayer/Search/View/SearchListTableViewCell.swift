//
//  SearchListTableViewCell.swift
//  MyApp
//
//  Created by Dmitry on 28.06.2022.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {
  
  private(set) var nameLabel = DescriptionLabel()
  
  weak var viewModel: SearchViewCellModelProtocol? {
    willSet(viewModel) {
      guard let viewModel = viewModel else { return }
      nameLabel.text = viewModel.searchCityName
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
    addSubview(nameLabel)
  }

  private func setupFonts() {
    nameLabel.font = AppFont.regular(size: 16)
    nameLabel.textColor = .black
  }
  
  private func addConstraints() {

    NSLayoutConstraint.activate([

      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adapted(dimensionSize: 19, to: .height)),
      nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      nameLabel.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .width)),
      nameLabel.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 19, to: .height))
      ])
  }
}
