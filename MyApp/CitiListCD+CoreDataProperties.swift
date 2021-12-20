//
//  CitiListCD+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 18.12.2021.
//
//

import Foundation
import CoreData


extension CitiListCD {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CitiListCD> {
        return NSFetchRequest<CitiListCD>(entityName: "CitiListCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var lon: Double
    @NSManaged public var lat: Double
    @NSManaged public var country: String

}

extension CitiListCD : Identifiable {

}
