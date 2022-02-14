//
//  SettingsViewController.swift
//  MyApp
//
//  Created by Dmitry on 06.01.2022.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {
  // MARK: - Private types
  private let settingsView = SettingsView()
  private var viewModel: SettingsViewModelProtocol
  
  init(viewModel: SettingsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIViewController lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateView()
    setupViews()
    setupConstraints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    settingsView.layer.cornerRadius = Constants.Design.cornerRadius
    settingsView.layer.masksToBounds = true
    
  }
  // MARK: - Private functions
  
  private func updateView() {
    viewModel.updateViewData = { [weak self] viewData in
      self?.settingsView.viewData = viewData
    }
  }
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    self.navigationItem.setHidesBackButton(true, animated: false)
    view.addSubview(settingsView)
    
    settingsView.delegate = self
  }
  
  private func setupConstraints() {
    settingsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      settingsView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      settingsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.Design.horizontalViewPadding),
      settingsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.Design.horizontalViewPadding),
      settingsView.heightAnchor.constraint(equalToConstant: Constants.Design.viewHeight)
    ])
  }
}
// MARK: - UIViewController delegates

extension SettingsViewController: SettingsViewProtocol {
  func unitPressed() {
    viewModel.unitPressed()
  }
  
  func unitChanged(unit: Settings, type: UnitOptions?) {
    guard let type = type else { return }
    viewModel.changeSettings(unit: unit, type: type)
  }
  
  func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  func privacyPressed() {
    if let url = URL(string: Constants.Network.privacyURL) {
      let config = SFSafariViewController.Configuration()
      let safariViewController = SFSafariViewController(url: url, configuration: config)
      present(safariViewController, animated: true)
    }
  }
  
  func aboutPressed() {
    let aboutTitle = NSLocalizedString("aboutDescription", comment: "About Title")
    let aboutText = NSLocalizedString("aboutText", comment: "About Text")
    let alert = UIAlertController(title: aboutTitle, message: aboutText, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
