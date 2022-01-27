//
//  WeatherModel.swift
//  MyApp
//
//  Created by Dmitry on 29.12.2021.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
  var current: Current
  var hourly: [Current]
  var daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

// MARK: - Current
struct Current: Codable {
  let dt: Int
      let sunrise, sunset: Int?
      var temp, feelsLike: Double
  var pressure, humidity: Int
      let dewPoint, uvi: Double
      let clouds, visibility: Int
  var windSpeed: Double
      let windDeg: Int
      let windGust: Double?
      let weather: [Weather]
      let snow: Snow?
      let pop: Double?

    enum CodingKeys: String, CodingKey {
      case dt, sunrise, sunset, temp
            case feelsLike = "feels_like"
            case pressure, humidity
            case dewPoint = "dew_point"
            case uvi, clouds, visibility
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case windGust = "wind_gust"
            case weather, snow, pop
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}
// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String?
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
  var temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let clouds: Int
    let pop: Double?
    let uvi: Double
    let rain: Double?
    let snow: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain, snow
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
  var day, min, max, night: Double
    let eve, morn: Double
}
