//
//  NetworkErrors.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

enum NetworkErrors: String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum ResponseErrors<String> {
    case success
    case failure(String)
}
