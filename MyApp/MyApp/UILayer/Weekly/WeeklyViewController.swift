//
//  WeeklyViewController.swift
//  MyApp
//
//  Created by Dmitry on 29.12.2021.
//

import UIKit

class WeeklyViewController: UIViewController {

  let weeklyView = WeeklyWeatherView()
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  private let networkManager = NetworkManager()
  //private let cityId: Int
  private var weeklyCity: WeatherModel?
  
  
  init(model: WeatherModel?) {
    weeklyCity = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UIViewController lifecycle methods
  override func loadView() {
    super.loadView()
    self.view = weeklyView
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      weeklyView.weeklyListTableView.delegate = self
      weeklyView.weeklyListTableView.dataSource = self
     // getWeeklyWeather(for: cityId)
    }
  func getWeeklyWeather(for city: Int) {
    
//    self.coreDataManager.cityListPredicate = NSPredicate(format: "id == %i", self.cityId)
//    self.coreDataManager.loadListData()
//    guard let city = self.coreDataManager.fetchedListController.fetchedObjects?.first
//           else { return }
//    guard
//      let correctedLon = Double(String(format: "%.2f", city.lon)),
//      let correctedLat = Double(String(format: "%.2f", city.lat))
//    else { return }
//
//  networkManager.getWeeklyWeather(lon: correctedLon, lat: correctedLat) { result in
//    switch result {
//    case .success(let weather):
//      DispatchQueue.main.async {
//      //  print(weather)
//        self.weeklyCity = weather
//        self.weeklyView.weeklyListTableView.reloadData()
//        self.coreDataManager.cityListPredicate = NSPredicate(format: "id == %i", self.cityId)
//        self.coreDataManager.loadSavedData()
//        let city = self.coreDataManager.fetchedResultsController.fetchedObjects?.first
//        self.coreDataManager.configureTopView(from: weather, list: city)
//        self.coreDataManager.configureBottomView(from: weather, list: city)
//        self.coreDataManager.saveContext()
//
//        self.loadingVC.remove()
//        self.currentWeather = weather
//        self.weatherView.configure(with: weather)
//        self.weatherView.collectionView.reloadData()
  //    }
      
//    case .failure(let error):
//      print(error.rawValue)
//    }
//  }
}

}


extension WeeklyViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weeklyCity?.daily.count ?? 0
   // return 0
  }
  
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return adapted(dimensionSize: 0, to: .height)
//  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: .zero)
    headerView.backgroundColor = UIColor(named: "backgroundColor")
    return headerView
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell", for: indexPath) as? WeeklyTableViewCell,   let model = weeklyCity?.daily[indexPath.row]
    else { return UITableViewCell() }
            
            
  
   
    //cell.dayLabel.text = "\(indexPath.row)"
   // cell.conditionImage.image = UIImage(systemName:"thermometer.sun")?.withTintColor(.white, renderingMode: .alwaysOriginal)
      cell.configure(with: model)
    return cell
    
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
}

