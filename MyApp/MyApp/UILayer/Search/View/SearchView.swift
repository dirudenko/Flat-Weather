//
//  SearchView.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import UIKit
import CoreData

protocol SearchViewProtocol: AnyObject {
  func setViewFromSearch(fot city: [MainInfo], at index: Int)
  func setViewFromCityList(fot city: [MainInfo], at index: Int)
  func backButtonTapped()
}

class SearchView: UIView {
  // MARK: - Private types
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.placeholder = "Найти город..."
    searchBar.searchTextField.layer.cornerRadius = 16
    searchBar.searchTextField.borderStyle = .roundedRect
    searchBar.barTintColor = .clear
    searchBar.backgroundColor = UIColor.clear
    searchBar.isTranslucent = true
    searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    searchBar.searchTextField.backgroundColor = .systemGray6
    return searchBar
  }()
  
  private let cityListTableView = TableView(celltype: .CityListTableViewCell)
  private let searchTableView = TableView(celltype: .StandartTableViewCell)
  // private let animation = AnimationView()
  private var searchViewCellModel: SearchViewCellModelProtocol
  private(set) var loadingVC = LoadingView()
  private(set) var backButton = Button(systemImage: "arrow.backward")
  private let gradient = Constants.Design.gradient
  // MARK: - Public types
  var delegate: SearchViewProtocol?
  var city = [SearchModel](){
    didSet {
      searchTableView.reloadData()
    }
  }
  var viewData: SearchViewData = .initial {
    didSet {
      setNeedsLayout()
    }
  }
  // MARK: - Initialization

  init(frame: CGRect, searchViewCellModel: SearchViewCellModelProtocol) {
    self.searchViewCellModel = searchViewCellModel
    super.init(frame: frame)
    updateView()
    setupLayouts()
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradient.frame = self.bounds
    switch viewData {
    case .initial:
      // animation.removeFromSuperview()
      searchBar.resignFirstResponder()
      loadingVC.isHidden = true
      cityListTableView.isHidden = false
      searchTableView.isHidden = true
      if searchViewCellModel.coreDataManager.entityIsEmpty() {
        backButton.isHidden = true
      } else {
        backButton.isHidden = false
      }
    case .load:
      loadingVC.isHidden = false
      cityListTableView.isHidden = true
      searchTableView.isHidden = false
    case .success(let model):
      city = model
      loadingVC.makeInvisible()
      searchTableView.isHidden = false
      cityListTableView.isHidden = true
      //      animation.removeFromSuperview()
      //      searchBar.isHidden = false
      //      searchBar.becomeFirstResponder()
    case .failure:
      break
    }
  }
  // MARK: - Private functions

  private func setupLayouts() {
    addSubview(searchBar)
    addSubview(searchTableView)
    addSubview(cityListTableView)
    // addSubview(animation)
    addSubview(loadingVC)
    addSubview(backButton)
    bringSubviewToFront(loadingVC)
    backButton.addTarget(self, action: #selector(didTapBack), for: .touchDown)
    loadingVC.makeInvisible()
    searchBar.delegate = self
    searchTableView.delegate = self
    searchTableView.dataSource = self
    cityListTableView.delegate = self
    cityListTableView.dataSource = self
    searchViewCellModel.coreDataManager.fetchedResultsController.delegate = self
    layer.insertSublayer(gradient, at:0)
  }
  
  private func updateView() {
    searchViewCellModel.updateViewData = { [weak self] viewData in
      self?.viewData = viewData
    }
  }
  
  @objc private func didTapBack() {
    delegate?.backButtonTapped()
  }
}
// MARK: - UITableView delegates
extension SearchView: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    switch tableView {
    case searchTableView:
      return 1
    case cityListTableView:
      return searchViewCellModel.setSections(at: .CityListTableViewCell)
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case searchTableView:
      return city.count
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
    headerView.backgroundColor = .clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case searchTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
      let cityName = "\(city[indexPath.row].name)"
      let cityCountry = "\(city[indexPath.row].country)"
      cell.textLabel?.text = cityName + " " + cityCountry
      cell.backgroundColor = .clear
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
      let model = searchViewCellModel.setCity(model: city[indexPath.row], for: .StandartTableViewCell)
      delegate?.setViewFromCityList(fot: model, at: model.count - 1)
    case cityListTableView:
      let model = searchViewCellModel.setCity(model: nil, for: .CityListTableViewCell)
      delegate?.setViewFromCityList(fot: model, at: indexPath.section)
    default: return
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    switch tableView {
    case searchTableView:
      return false
    case cityListTableView:
      return true
    default:
      return false
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch tableView {
    case searchTableView:
      return
    case cityListTableView:
      if editingStyle == .delete
      {
        searchViewCellModel.removeObject(at: indexPath.section)
        if searchViewCellModel.coreDataManager.entityIsEmpty() {
          backButton.isHidden = true
        }
      }
    default: return
    }
  }
}
// MARK: - UITableView delegates

extension SearchView: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchTableView.isHidden = true
    cityListTableView.isHidden = false
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchViewCellModel.searchText(text: searchText)
  }
}

extension SearchView: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    cityListTableView.beginUpdates()
  }
  
  func controller(_ controller:
                  NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
    switch type {
    case .delete:
      if let indexPath = indexPath {
        let section = indexPath.row
        cityListTableView.deleteSections([section], with: .fade)
        
      }
    case .insert:
      if let indexPath = newIndexPath {
        let section = IndexSet(integer: indexPath.section)
        
        cityListTableView.insertSections(section, with: .fade)
      }
    case .update:
      if let indexPath = indexPath {
        guard let cell = cityListTableView.cellForRow(at: indexPath) as? CityListTableViewCell,
              let model = (searchViewCellModel.getObjects(at: indexPath.section)) else { break }
        cell.configure(with: model)
      }
      
    case .move:
      if let indexPath = indexPath {
        let section = indexPath.row
        cityListTableView.deleteSections([section], with: .fade)
      }
      if let newIndexPath = newIndexPath {
        let section = IndexSet(integer: newIndexPath.section)
        cityListTableView.insertSections(section, with: .fade)
      }
    default:
      print("Unexpected NSFetchedResultsChangeType")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    cityListTableView.endUpdates()
  }
}
// MARK: - Constraints

extension SearchView {
  private func addConstraints() {
    let safeArea = self.safeAreaLayoutGuide
    loadingVC.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      
      searchBar.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: adapted(dimensionSize: 9, to: .height)),
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
      
      
      backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      backButton.widthAnchor.constraint(equalToConstant: 32),
      backButton.heightAnchor.constraint(equalToConstant: 32),
      //      animation.topAnchor.constraint(equalTo: self.centerYAnchor, constant: adapted(dimensionSize: -50, to: .height)),
      //      animation.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: adapted(dimensionSize: -50, to: .width)),
      //      animation.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .width)),
      //      animation.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 200, to: .height)),
      
      loadingVC.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      loadingVC.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
    ])
  }
}


