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

    @NSManaged public var temp: Int16
    @NSManaged public var name: String
    @NSManaged public var fellsLike: Int16
    @NSManaged public var date: Int64
    @NSManaged public var rain: Int16
    @NSManaged public var iconId: Int16
    @NSManaged public var weather: MainInfo?

}

extension Hourly : Identifiable {

}
