//
//  Dictionary+ .swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation

extension Dictionary {
    func keyedValue(key: Key) -> Value? {
        return self[key] ?? nil
    }
}
