//
//  UnitsTypes+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 26.01.2022.
//
//

import Foundation
import CoreData

extension UnitsTypes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnitsTypes> {
        return NSFetchRequest<UnitsTypes>(entityName: "UnitsTypes")
    }

    @NSManaged public var tempType: Int16
    @NSManaged public var pressureType: Int16
    @NSManaged public var windType: Int16
    @NSManaged public var main: MainInfo?

}

extension UnitsTypes: Identifiable {

}
