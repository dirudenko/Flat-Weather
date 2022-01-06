//
//  CityList+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 05.01.2022.
//
//

import Foundation
import CoreData


extension CityList {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CityList> {
        return NSFetchRequest<CityList>(entityName: "CityList")
    }

    @NSManaged public var country: String
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}

extension CityList : Identifiable {

}
