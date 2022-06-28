//
//  SearchViewController.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

final class SearchViewController: UIViewController {
  
  // MARK: - Private types
  private var searchView: SearchView
  private var isEdit = false
  // MARK: - Initialization
  init(searchViewViewModel: SearchViewViewModelProtocol) {
    self.searchView = SearchView(frame: .zero, searchViewViewModel: searchViewViewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - UIViewController lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    searchView.layer.cornerRadius = Constants.Design.cornerRadius
    searchView.layer.masksToBounds = true
  }
  
  // MARK: - Private functions
  private func setupViews() {
    view.backgroundColor = .systemBackground
    view.addSubview(searchView)
    searchView.delegate = self
    searchView.alertDelegate = self
    self.navigationItem.setHidesBackButton(true, animated: false)
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    view.accessibilityIdentifier = "searchView"
  }
}
// MARK: - UIViewController delegates
extension SearchViewController: SearchViewDelegate {
  
  func setViewFromCityList(fot city: [MainInfo], at index: Int) {
    let viewController = BuilderService.buildPageViewController(at: index)
    navigationController?.setViewControllers([viewController], animated: true)
  }
  
  func setViewFromSearch(fot city: [MainInfo], at index: Int) {
    let viewController = BuilderService.buildPageViewController(at: index)
    navigationController?.setViewControllers([viewController], animated: true)
  }
  
  func backButtonTapped(_ isEdited: Bool) {
      switch isEdited {
      case true:
        let viewController = BuilderService.buildPageViewController()
        self.navigationController?.setViewControllers([viewController], animated: true)
      case false:
        self.navigationController?.popViewController(animated: true)
      }
    }
  }

extension SearchViewController: AlertProtocol {
  func showAlert(text: String) {
    self.showSystemAlert(text: text)
  }
}
// MARK: - UIViewController extensions
extension SearchViewController {
  func setupConstraints() {
    searchView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.Design.horizontalViewPadding),
      searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.Design.horizontalViewPadding),
      searchView.heightAnchor.constraint(equalToConstant: Constants.Design.viewHeight)
    ])
  }
}

extension SearchViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
