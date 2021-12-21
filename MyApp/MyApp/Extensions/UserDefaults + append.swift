//
//  UserDefaults + append.swift
//  MyApp
//
//  Created by Dmitry on 20.12.2021.
//

import Foundation

extension UserDefaults {
  func appendList(id: Int64) {
    guard var list = UserDefaults.standard.object(forKey: "list") as? [Int] else { return }
    if list.isEmpty {
      list.append(Int(id))
    } else {
    list.forEach {
      if $0 != Int(id)  {
        list.append(Int(id))
      }
    }
    }
    UserDefaults.standard.removeObject(forKey: "list")
    UserDefaults.standard.set(list, forKey: "list")
    print(list)
  }
}
