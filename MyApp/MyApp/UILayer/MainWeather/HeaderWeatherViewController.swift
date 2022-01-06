//
//  ViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class HeaderWeatherViewController: UIViewController {
  
  private let networkManager = NetworkManager()
  var currentWeather: MainInfo?
  let weatherView = HeaderWeatherView()
  let loadingVC = LoadingViewController()
  private let coreDataManager = CoreDataManager(modelName: "MyApp")
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - UIViewController lifecycle methods
  
  override func loadView() {
    super.loadView()
    self.view = weatherView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weatherView.collectionView.dataSource = self
    weatherView.collectionView.delegate = self
    weatherView.collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
    add(loadingVC)
   // fetchDataFromCoreData()
    //  print("HeaderWeaherViewController viewDidLoad")
    // getWeather(for: cityId)
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let headerFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    loadingVC.view.frame = headerFrame
  }
  // MARK: - Private functions
  // Получение данных из Кордаты и их вывод на экран перед выполнением запроса в сеть
//  private func fetchDataFromCoreData() {
//    coreDataManager.cityResultsPredicate = NSPredicate(format: "id == %i", cityId)
//    coreDataManager.loadSavedData()
//    // print(coreDataManager.fetchedResultsController.fetchedObjects?.count)
//    guard let data = coreDataManager.fetchedResultsController.fetchedObjects else { return }
//   // guard let currentWeather = dataConverter(data: data) else { return }
//    self.currentWeather = currentWeather
//    weatherView.configure(with: currentWeather)
//  }
//
  /// Конвертирование данных, полученных из Кордаты, в тип, необходимый для вывода на экран
//  private func dataConverter(data: [MainInfo]) -> CurrentWeather? {
//    guard let city = data.first else { return nil }
//    let main = Main(humidity: Int(city.bottomWeather?.humidity ?? 0),
//                    feelsLike: 0,
//                    tempMin: 0,
//                    tempMax: 0,
//                    temp: city.topWeather?.temperature ?? 0,
//                    pressure: Int(city.bottomWeather?.pressure ?? 0),
//                    seaLevel: 100,
//                    grndLevel: 0
//    )
//    let coord = Coord(lon: city.lon, lat: city.lat)
//    let wind = Wind(speed: city.bottomWeather?.wind ?? 0, deg: 0, gust: 0.0)
//    let sys = Sys(id: 0, country: "", sunset: 0, type: 0, sunrise: 0)
//    let weather = Weather(id: Int(city.topWeather?.iconId ?? 0),
//                          main: "",
//                          icon: "",
//                          weatherDescription: city.topWeather?.desc ?? "---")
//    let clouds = Clouds(all: 1)
//    let currentWeather = CurrentWeather(base: "",
//                                        id: Int(city.id),
//                                        dt: Int(city.topWeather?.date ?? 0 ),
//                                        main: main,
//                                        coord: coord,
//                                        wind: wind,
//                                        sys: sys,
//                                        weather: [weather],
//                                        visibility: 0,
//                                        clouds: clouds,
//                                        timezone: 0,
//                                        cod: 0,
//                                        name: city.name )
//    return currentWeather
//  }
  
}
// MARK: - UIViewController delegates

extension HeaderWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentWeather != nil ? 4 : 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell,
          let model = currentWeather
    else { return UICollectionViewCell() }
    cell.configure(with: model, index: indexPath.row)
    return cell
  }
}

