//
//  MockData.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation

struct MockData {
lazy var mockCity = CityWeather(base: "stations",
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

private let cloud = Clouds(all: 1)
private let wind = Wind(speed: 1.5, deg: 350, gust: 0)
private let weather = Weather(id: 800,
                      main: "Clear",
                      icon: "01d",
                      weatherDescription: "clear sky")

private let main = Main(humidity: 40,
                feelsLike: 281.86,
                tempMin: 280.37,
                tempMax: 284.26,
                temp: 282.55,
                pressure: 1023,
                seaLevel: 100,
                grndLevel: 0)

private let coord = Coord(lon: -122.08, lat: 37.39)

private let sys = Sys(id: 5122,
              country: "US",
              sunset: 1560396563,
              type: 1,
              sunrise: 1560343627)

}

