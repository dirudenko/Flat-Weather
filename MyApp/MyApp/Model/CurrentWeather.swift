//
//  CityWeather.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

struct CurrentWeather: Codable {
      let base: String
      let id, dt: Int
      let main: Main
      let coord: Coord
      let wind: Wind
      let sys: Sys
      let weather: [Weather]
      let visibility: Int
      let clouds: Clouds
      let timezone, cod: Int
      let name: String
  }

  // MARK: - Clouds
  struct Clouds: Codable {
      let all: Int
  }

  // MARK: - Coord
  struct Coord: Codable {
      let lon, lat: Double
  }

  // MARK: - Main
  struct Main: Codable {
      let humidity: Int
      let feelsLike, tempMin, tempMax, temp: Double
      let pressure, seaLevel, grndLevel: Int

      enum CodingKeys: String, CodingKey {
          case humidity
          case feelsLike = "feels_like"
          case tempMin = "temp_min"
          case tempMax = "temp_max"
          case temp, pressure
          case seaLevel = "sea_level"
          case grndLevel = "grnd_level"
      }
  }

  // MARK: - Sys
  struct Sys: Codable {
      let id: Int
      let country: String
      let sunset, type, sunrise: Int
  }

  // MARK: - Weather
  struct Weather: Codable {
      let id: Int
      let main, icon, weatherDescription: String

      enum CodingKeys: String, CodingKey {
          case id, main, icon
          case weatherDescription = "description"
      }
  }

  // MARK: - Wind
  struct Wind: Codable {
      let speed: Double
      let deg: Int
      let gust: Double
  }


