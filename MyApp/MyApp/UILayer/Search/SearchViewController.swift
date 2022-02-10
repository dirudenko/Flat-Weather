//
//  SearchViewController.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

final class SearchViewController: UIViewController {

  // MARK: - Private types
  private var searchView: SearchView!
  private var searchViewCellModel: SearchViewCellModelProtocol
  private var didEdit = false
  // MARK: - Initialization
  init(searchViewCellModel: SearchViewCellModelProtocol) {
    self.searchViewCellModel = searchViewCellModel
    self.searchView = SearchView(frame: .zero, searchViewCellModel: searchViewCellModel)
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
    searchView.layer.cornerRadius = adapted(dimensionSize: 30, to: .height)
    searchView.layer.masksToBounds = true
  }

  // MARK: - Private functions
  private func setupViews() {
    view.backgroundColor = .systemBackground
    view.addSubview(searchView)
    searchView.delegate = self
    self.navigationItem.setHidesBackButton(true, animated: false)
    view.accessibilityIdentifier = "searchView"
  }

  private func updateView() {
    searchViewCellModel.updateViewData = { [weak self] viewData in
      self?.searchView.viewData = viewData
    }
  }
}
// MARK: - UIViewController delegates
extension SearchViewController: SearchViewProtocol {
  func didEdit(at section: Int) {
    didEdit = true
  }

  func setViewFromCityList(fot city: [MainInfo], at index: Int) {
    let viewController = BuilderService.buildPageViewController(at: index)
    navigationController?.setViewControllers([viewController], animated: true)
  }

  func setViewFromSearch(fot city: [MainInfo], at index: Int) {
    let viewController = BuilderService.buildPageViewController(at: index)
    navigationController?.setViewControllers([viewController], animated: true)
  }

  func backButtonTapped() {
    if didEdit {
      let viewController = BuilderService.buildPageViewController()
      navigationController?.setViewControllers([viewController], animated: true)
    } else {
    navigationController?.popViewController(animated: true)
    }
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
