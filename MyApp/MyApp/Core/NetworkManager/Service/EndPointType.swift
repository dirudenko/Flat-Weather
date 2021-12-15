//
//  EndPointType.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
