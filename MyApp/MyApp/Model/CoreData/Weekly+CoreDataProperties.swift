//
//  Weekly+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 18.01.2022.
//
//

import Foundation
import CoreData


extension Weekly {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weekly> {
        return NSFetchRequest<Weekly>(entityName: "Weekly")
    }

    @NSManaged public var date: Int64
    @NSManaged public var rain: Int16
    @NSManaged public var tempDay: Int16
    @NSManaged public var tempNight: Int16
    @NSManaged public var iconId: Int16
    @NSManaged public var weather: MainInfo?

}

extension Weekly : Identifiable {

}
