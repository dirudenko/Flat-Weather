//
//  List+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 21.12.2021.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var id: Int16
    @NSManaged public var inList: NSSet?

}

// MARK: Generated accessors for inList
extension List {

    @objc(addInListObject:)
    @NSManaged public func addToInList(_ value: MainInfo)

    @objc(removeInListObject:)
    @NSManaged public func removeFromInList(_ value: MainInfo)

    @objc(addInList:)
    @NSManaged public func addToInList(_ values: NSSet)

    @objc(removeInList:)
    @NSManaged public func removeFromInList(_ values: NSSet)

}

extension List : Identifiable {

}
