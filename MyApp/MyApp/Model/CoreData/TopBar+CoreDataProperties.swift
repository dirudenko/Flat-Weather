//
//  TopBar+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//
//

import Foundation
import CoreData


extension TopBar {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TopBar> {
        return NSFetchRequest<TopBar>(entityName: "TopBar")
    }

    @NSManaged public var date: Int64
    @NSManaged public var iconId: Int16
    @NSManaged public var pressure: Int16
    @NSManaged public var temperature: Double
    @NSManaged public var desc: String?
    @NSManaged public var citiList: MainInfo?

}

extension TopBar : Identifiable {

}
