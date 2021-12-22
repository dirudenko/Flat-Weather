//
//  CGFloat.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//

import UIKit

extension CGFloat {
    var adaptedFontSize: CGFloat {
        adapted(dimensionSize: self, to: dimension)
    }
}
