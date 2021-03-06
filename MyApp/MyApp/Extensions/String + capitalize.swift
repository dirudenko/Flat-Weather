//
//  String + capitalize.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation

extension String {
  /// вывод строки с заглавной буквы
    var capitalizedFirstLetter: String {
          let string = self
          return string.replacingCharacters(in: startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
}
