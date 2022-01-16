//
//  SearchView.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit

protocol SearchViewProtocol {
  func setViewFromSearch(fot city: [MainInfo], at index: Int)
  func setViewFromCityList(fot city: [MainInfo], at index: Int)
}

class SearchView: UIView {
  
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.placeholder = "Найти город..."
    searchBar.searchTextField.layer.cornerRadius = 16
    searchBar.searchTextField.borderStyle = .roundedRect
    searchBar.isHidden = true
    searchBar.barTintColor = UIColor(named: "backgroundColor")
    searchBar.searchTextField.backgroundColor = .systemGray6
    return searchBar
  }()
  
  private let cityListTableView = TableView(celltype: .CityListTableViewCell)
  private let searchTableView = TableView(celltype: .StandartTableViewCell)
  private let animation = AnimationView()
  private var searchViewCellModel: SearchViewCellModelProtocol
  
  var delegate: SearchViewProtocol?
  
  var viewData: SearchViewData = .initial {
    didSet {
      setNeedsLayout()
    }
  }
  
  init(frame: CGRect, searchViewCellModel: SearchViewCellModelProtocol) {
    self.searchViewCellModel = searchViewCellModel
    
    super.init(frame: frame)
    setupLayouts()
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    switch viewData {
    case .initial:
      break
    case .success:
      animation.removeFromSuperview()
      searchBar.isHidden = false
      searchBar.becomeFirstResponder()
    case .failure:
      break
    }
  }
  
  private func setupLayouts() {
    addSubview(searchBar)
    addSubview(searchTableView)
    addSubview(cityListTableView)
    addSubview(animation)
    searchBar.delegate = self
    searchTableView.delegate = self
    searchTableView.dataSource = self
    cityListTableView.delegate = self
    cityListTableView.dataSource = self
  }
}


// MARK: - UIViewController delegates
extension SearchView: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    switch tableView {
    case searchTableView:
      return searchViewCellModel.setSections(at: .StandartTableViewCell)
    case cityListTableView:
      return searchViewCellModel.setSections(at: .CityListTableViewCell)
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case searchTableView:
      return searchViewCellModel.setRows(at: section)
    case cityListTableView:
      return 1
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch tableView {
    case searchTableView:
      return 0
    case cityListTableView:
      return adapted(dimensionSize: 16, to: .height)
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: .zero)
    headerView.backgroundColor = UIColor(named: "backgroundColor")
    return headerView
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case searchTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
      cell.textLabel?.text = searchViewCellModel.setText(at: indexPath)
      cell.backgroundColor = UIColor(named: "backgroundColor")
      return cell
      
    case cityListTableView:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as? CityListTableViewCell,
            let model = searchViewCellModel.getObjects(at: indexPath.section)
      else { return UITableViewCell() }
      cell.configure(with: model)
      return cell
    default : return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch tableView {
    case searchTableView:
      let model = searchViewCellModel.setCity(at: indexPath, for: .StandartTableViewCell)
      delegate?.setViewFromCityList(fot: model, at: model.count - 1)
    case cityListTableView:
      let model = searchViewCellModel.setCity(at: indexPath, for: .CityListTableViewCell)
      delegate?.setViewFromCityList(fot: model, at: indexPath.section)
    default: return
    }
  }
  
}

extension SearchView: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchTableView.isHidden = true
    cityListTableView.isHidden = false
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchViewCellModel.searchText(text: searchText)
    searchTableView.isHidden = false
    cityListTableView.isHidden = true
    searchTableView.reloadData()
    if searchText.isEmpty {
      searchTableView.isHidden = true
      cityListTableView.isHidden = false
    }
  }
}

extension SearchView {
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      
      searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      searchBar.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      searchBar.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      searchBar.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 50, to: .height)),
      
      searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      searchTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      searchTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      searchTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      cityListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
      cityListTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      cityListTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: adapted(dimensionSize: -16, to: .width)),
      cityListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      
      animation.topAnchor.constraint(equalTo: self.centerYAnchor, constant: adapted(dimensionSize: -50, to: .height)),
      animation.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -50, to: .width)),
      animation.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .width)),
      animation.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .height))
      
    ])
  }
}

