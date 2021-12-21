//
//  BottomBar+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//
//

import Foundation
import CoreData


extension BottomBar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BottomBar> {
        return NSFetchRequest<BottomBar>(entityName: "BottomBar")
    }

    @NSManaged public var humidity: Int16
    @NSManaged public var pressure: Int16
    @NSManaged public var rain: Int16
    @NSManaged public var wind: Double
    @NSManaged public var weather: MainInfo?

}

extension BottomBar : Identifiable {

}
