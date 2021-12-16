//
//  LoadingViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class LoadingViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.color = .systemCyan
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.startAnimating()
    view.addSubview(spinner)
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}
