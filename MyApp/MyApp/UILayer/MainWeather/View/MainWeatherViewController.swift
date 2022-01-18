//
//  TestViewController.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

final class MainWeatherViewController: UIViewController {
  // MARK: - Private types
  private var currentWeatherView = CurrentWeatherView()
  private var hourlyWeatherView = HourlyWeatherView()
  private let forcatsButton = Button()
  private var weeklyWeatherView = WeeklyWeatherView()
  private var viewModel: MainWeatherViewModelProtocol

  // MARK: - Private variables
  private var isPressed = false
  private var weeklyWeatherViewTopSmall: NSLayoutConstraint?
  private var weeklyWeatherViewTopBig: NSLayoutConstraint?
  private var headerWeatherViewHeightSmall: NSLayoutConstraint?
  private var headerWeatherViewHeightBig: NSLayoutConstraint?
  // MARK: - Initialization
  init(viewModel: MainWeatherViewModelProtocol) {
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
    setupLayouts()
    checkSettings()
    viewModel.startFetch()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    /// проверка времени для повторного запроса в сеть
    if viewModel.checkDate() {

      viewModel.loadWeather()
    }
  }
  
  // MARK: - Private functions
  /// подписывание на изменение состояний View
  private func updateView() {
    viewModel.updateViewData = { [weak self] viewData in
      self?.currentWeatherView.viewData = viewData
      self?.hourlyWeatherView.viewData = viewData
      self?.weeklyWeatherView.viewData = viewData
    }
  }
  
  private func setupLayouts() {
    view.backgroundColor = .systemBackground
    view.addSubview(currentWeatherView)
    view.addSubview(hourlyWeatherView)
    view.addSubview(weeklyWeatherView)
    setupConstraints()
    let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
    let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
    
    swipeGestureRecognizerDown.direction = .down
    swipeGestureRecognizerUp.direction = .up
    view.addGestureRecognizer(swipeGestureRecognizerDown)
    view.addGestureRecognizer(swipeGestureRecognizerUp)
    currentWeatherView.delegate = self

  }
}
// MARK: - Delegates
extension MainWeatherViewController: HeaderButtonsProtocol {
  func optionsButtonTapped() {
    let settingsViewController = SettingsViewController()
    navigationController?.pushViewController(settingsViewController, animated: true)
  }
  
  func plusButtonTapped() {
    print("Plus button tapped")
    let searchViewController = BuilderService.buildSearchViewController()
    navigationController?.pushViewController(searchViewController, animated: true)
 }
}
// MARK: - Constraints
extension MainWeatherViewController {
  
  @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
    switch sender.direction {
    case .up:
      currentWeatherView.changeConstraints(isPressed: true)
      
      headerWeatherViewHeightBig?.isActive = false
      headerWeatherViewHeightSmall?.isActive = true
      
      weeklyWeatherViewTopBig?.isActive = false
      weeklyWeatherViewTopSmall?.isActive = true
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    case .down:
      currentWeatherView.changeConstraints(isPressed: false)
      
      headerWeatherViewHeightSmall?.isActive = false
      headerWeatherViewHeightBig?.isActive = true
      
      weeklyWeatherViewTopSmall?.isActive = false
      weeklyWeatherViewTopBig?.isActive = true
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    default: break
    }
  }
  
  private func setupConstraints() {
    currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
    hourlyWeatherView.translatesAutoresizingMaskIntoConstraints = false
    weeklyWeatherView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      weeklyWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor),
      weeklyWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor),
      weeklyWeatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      currentWeatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 62, to: .height)),
      currentWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 16, to: .width)),
      currentWeatherView.widthAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .width)),
      
      hourlyWeatherView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: adapted(dimensionSize: 16, to: .height)),
      hourlyWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      hourlyWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: adapted(dimensionSize: 0, to: .width)),
      hourlyWeatherView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 140, to: .height))
    ])
    
    weeklyWeatherViewTopBig = weeklyWeatherView.topAnchor.constraint(equalTo: view.bottomAnchor)
    weeklyWeatherViewTopBig?.isActive = true
    weeklyWeatherViewTopSmall = weeklyWeatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: adapted(dimensionSize: 587, to: .height))
    
    headerWeatherViewHeightBig = currentWeatherView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 565, to: .height))
    headerWeatherViewHeightBig?.isActive = true
    headerWeatherViewHeightSmall = currentWeatherView.heightAnchor.constraint(equalToConstant: adapted(dimensionSize: 353, to: .height))
  }
}



