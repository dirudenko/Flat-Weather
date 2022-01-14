//
//  Icons.swift
//  MyApp
//
//  Created by Dmitry on 16.12.2021.
//

import Foundation
/// Модель для присвоения иконки погоды в зависимости от полученного кода
struct IconHadler {
  static let iconDictionary: [Int: String] = [
                                              200:"cloud.heavyrain.fill",
                                              201:"cloud.bolt.rain.fill",
                                              202:"cloud.bolt.rain.fill",
                                              210:"cloud.bolt.rain.fill",
                                              211:"cloud.bolt.rain.fill",
                                              212:"cloud.bolt.rain.fill",
                                              221:"cloud.bolt.rain.fill",
                                              230:"cloud.bolt.rain.fill",
                                              231:"cloud.bolt.rain.fill",
                                              232:"cloud.bolt.rain.fill",
                                              300:"cloud.drizzle.fill",
                                              301:"cloud.drizzle.fill",
                                              302:"cloud.drizzle.fill",
                                              310:"cloud.drizzle.fill",
                                              311:"cloud.drizzle.fill",
                                              312:"cloud.drizzle.fill",
                                              313:"cloud.drizzle.fill",
                                              314:"cloud.drizzle.fill",
                                              321:"cloud.drizzle.fill",
                                              500:"cloud.sun.rain.fill",
                                              501:"cloud.sun.rain.fill",
                                              502:"cloud.rain.fill",
                                              503:"cloud.rain.fill",
                                              504:"cloud.rain.fill",
                                              511:"snowflake",
                                              520:"cloud.rain.fill",
                                              521:"cloud.heavyrain.fill",
                                              522:"cloud.heavyrain.fill",
                                              531:"cloud.heavyrain.fill",
                                              600:"snowflake.circle.fill",
                                              601:"snowflake.circle.fill",
                                              602:"snowflake.circle.fill",
                                              611:"snowflake.circle.fill",
                                              612:"snowflake.circle.fill",
                                              613:"snowflake.circle.fill",
                                              615:"snowflake.circle.fill",
                                              616:"snowflake.circle.fill",
                                              620:"snowflake.circle.fill",
                                              621:"snowflake.circle.fill",
                                              622:"snowflake.circle.fill",
                                              701:"wind",
                                              711:"wind",
                                              721:"wind",
                                              731:"wind",
                                              741:"wind",
                                              751:"wind",
                                              761:"wind",
                                              762:"wind",
                                              771:"wind",
                                              781:"tornado",
                                              800:"sun.max.fill",
                                              801:"cloud.sun.fill",
                                              802:"cloud.fill",
                                              803:"smoke.fill",
                                              804:"smoke.fill"
  ]
}



