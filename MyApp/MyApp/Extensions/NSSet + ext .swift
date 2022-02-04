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
    let array = self.map({ $0 as! T})
    return array
  }
}
