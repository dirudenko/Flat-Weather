//
//  CitiList.swift
//  MyApp
//
//  Created by Dmitry on 17.12.2021.
//

import Foundation

struct CitiList: Codable {
    let id: Int
    let name, state, country: String
    let coord: Coord
}

