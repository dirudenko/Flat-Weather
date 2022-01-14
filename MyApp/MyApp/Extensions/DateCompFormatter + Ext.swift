//
//  DateCompFormatter + Ext.swift
//  MyApp
//
//  Created by Dmitry on 14.01.2022.
//

import Foundation

extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
      self.allowedUnits = [.second]
        self.maximumUnitCount = 1
        self.unitsStyle = .abbreviated
        return self.string(from: fromDate, to: toDate)
    }
}
