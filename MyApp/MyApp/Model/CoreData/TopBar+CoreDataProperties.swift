//
//  TopBar+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 18.01.2022.
//
//

import Foundation
import CoreData

extension TopBar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopBar> {
        return NSFetchRequest<TopBar>(entityName: "TopBar")
    }

    @NSManaged public var date: Int64
    @NSManaged public var feelsLike: Double
    @NSManaged public var desc: String?
    @NSManaged public var iconId: String
    @NSManaged public var pressure: Int16
    @NSManaged public var temperature: Double
    @NSManaged public var weather: MainInfo?

}

extension TopBar: Identifiable {

}
