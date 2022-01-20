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
  private var viewModel: SearchViewModelProtocol
  
  // MARK: - Initialization
  init(viewModel: SearchViewModelProtocol, searchViewCellModel: SearchViewCellModelProtocol) {
    self.viewModel = viewModel
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
    viewModel.startFetch()
  }
  
  deinit {
    print("SearchVC deleted")
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
    searchView.backgroundColor = UIColor(named: "backgroundColor")
    searchView.delegate = self
    self.navigationItem.setHidesBackButton(true, animated: false)
  }
  
  private func updateView() {
    viewModel.updateViewData = { [weak self] viewData in
      self?.searchView.viewData = viewData
    }
  }
}
// MARK: - UIViewController delegates
extension SearchViewController: SearchViewProtocol {
  func setViewFromCityList(fot city: [MainInfo], at index: Int) {
    let vc  = CityListPageViewController(for: city, index: index)
    let navigationController = UINavigationController(rootViewController: vc)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.setViewControllers([vc], animated: true)
    present(navigationController, animated: false)
  }
  
  func setViewFromSearch(fot city: [MainInfo], at index: Int) {
    let vc  = CityListPageViewController(for: city, index: index)
    let navigationController = UINavigationController(rootViewController: vc)
    navigationController.setViewControllers([vc], animated: true)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: false)
  }
  
  func backButtonTapped() {
    let vc = BuilderService.buildPageViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
}
// MARK: - UIViewController extensions
extension SearchViewController{
  func setupConstraints() {
    searchView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      searchView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 766, to: .height))
    ])
  }
}
