//
//  NSSet + ext .swift
//  MyApp
//
//  Created by Dmitry on 18.01.2022.
//

import Foundation

extension NSOrderedSet {
  /// проебразование набора(Set) в массив
  func toArray<T>() -> [T] {
    // swiftlint:disable force_cast
    let array = self.map({ $0 as! T})
    // swiftlint:enable force_cast
    return array
  }
}
