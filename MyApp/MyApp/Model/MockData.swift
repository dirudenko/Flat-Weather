//
//  MockData.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation

struct MockData {
static let mockCity = CurrentWeather(base: "stations",
                           id: 420006353,
                           dt: 1560350645,
                           main: main,
                           coord: coord,
                           wind: wind,
                           sys: sys,
                           weather: [weather],
                           visibility: 16093,
                           clouds: cloud,
                           timezone: -25200,
                           cod: 200,
                           name: "Mountain View")

static let cloud = Clouds(all: 1)
static let wind = Wind(speed: 1.5, deg: 350, gust: 0)
static let weather = Weather(id: 800,
                      main: "Clear",
                      icon: "01d",
                      weatherDescription: "clear sky")

static let main = Main(humidity: 40,
                       feelsLike: 28.1,
                       tempMin: 28.0,
                       tempMax: 28.4,
                       temp: 28.2,
                pressure: 1023,
                seaLevel: 100,
                grndLevel: 0)

static let coord = Coord(lon: -122.08, lat: 37.39)

static let sys = Sys(id: 5122,
              country: "US",
              sunset: 1560396563,
              type: 1,
              sunrise: 1560343627)

}

