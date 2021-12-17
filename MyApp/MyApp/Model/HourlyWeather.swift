//
//  HourlyWeather.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import Foundation

// MARK: - Hour
struct HourlyWeather: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let hourly: [Hourly]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case hourly
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let dt: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let pop: Int

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, pop
    }
}

