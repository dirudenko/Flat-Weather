//
//  MainInfo+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//
//

import Foundation
import CoreData


extension MainInfo {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MainInfo> {
        return NSFetchRequest<MainInfo>(entityName: "MainInfo")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: Int64
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var topWeather: TopBar?
    @NSManaged public var bottomWeather: BottomBar?

}

extension MainInfo : Identifiable {

}
