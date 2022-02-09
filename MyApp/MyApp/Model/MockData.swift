//
//  MockData.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation

struct MockWeatherModel {
  static let city = WeatherModel(lat: 37.39,
                          lon: -122.08,
                          timezone: "",
                          timezoneOffset: -25200,
                          current: current,
                          hourly: [current],
                          daily: [daily])
  static let weather = Weather(id: 800, main: "Clear", weatherDescription: "clear sky", icon: "01d")
  static let current = Current(dt: 1560350645,
                        sunrise: 1560343627,
                        sunset: 1560396563,
                        temp: 28.2,
                        feelsLike: 28.1,
                        pressure: 1023,
                        humidity: 40,
                        dewPoint: 4,
                        uvi: 3,
                        clouds: 2,
                        visibility: 1,
                        windSpeed: 5,
                        windDeg: 3,
                        windGust: nil,
                        weather: [weather],
                        snow: nil,
                        pop: 40)
  static let daily = Daily(dt: 1560350645,
                           sunrise: 1560343627,
                           sunset: 1560396563,
                           moonrise: 1560350645,
                           moonset: 1560343627,
                           moonPhase: 5,
                           temp: temp,
                           feelsLike: feelsLike,
                           pressure: 1023,
                           humidity: 43,
                           dewPoint: 40,
                           windSpeed: 5,
                           windDeg: 2,
                           windGust: nil,
                           weather: [weather],
                           clouds: 2,
                           pop: nil,
                           uvi: 5,
                           rain: nil,
                           snow: nil)
  static let temp = Temp(day: 20, min: 20, max: 20, night: 20, eve: 20, morn: 20)
  static let feelsLike = FeelsLike(day: 22, night: 22, eve: 22, morn: 22)

}
