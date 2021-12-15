//
//  HTTPTask.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import Foundation

 typealias HTTPHeaders = [String:String]

 enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload...etc
}
