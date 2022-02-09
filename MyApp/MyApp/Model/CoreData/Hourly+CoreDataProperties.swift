//
//  Hourly+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 18.01.2022.
//
//

import Foundation
import CoreData

extension Hourly {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hourly> {
        return NSFetchRequest<Hourly>(entityName: "Hourly")
    }

    @NSManaged public var temp: Double
    @NSManaged public var name: String
    @NSManaged public var feelsLike: Double
    @NSManaged public var date: Int64
    @NSManaged public var rain: Int16
    @NSManaged public var iconId: String
    @NSManaged public var id: Int16
    @NSManaged public var weather: MainInfo?

}

extension Hourly: Identifiable {

}
