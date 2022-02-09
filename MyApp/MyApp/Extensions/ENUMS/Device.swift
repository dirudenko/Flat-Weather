//
//  Device.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//

import Foundation

import UIKit

enum Device {
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone13Pro
    case iPhone13Mini
    case iPhone13ProMax

    static let baseScreenSize: Device = .iPhone13Pro
}

extension Device: RawRepresentable {
    typealias RawValue = CGSize

    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 568):
            self = .iPhoneSE
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhone11Pro
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        case CGSize(width: 375, height: 812):
            self = .iPhone13Mini
        case CGSize(width: 390, height: 844):
            self = .iPhone13Pro
        case CGSize(width: 428, height: 826):
            self = .iPhone13ProMax
        default:
            return nil
        }
    }

    var rawValue: CGSize {
        switch self {
        case .iPhoneSE:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPhone13Mini:
          return CGSize(width: 375, height: 812)
        case .iPhone13Pro:
          return CGSize(width: 390, height: 844)
        case .iPhone13ProMax:
          return CGSize(width: 428, height: 826)
        }
    }
}
