//
//  MainInfo+CoreDataProperties.swift
//  MyApp
//
//  Created by Dmitry on 18.01.2022.
//
//

import Foundation
import CoreData


extension MainInfo {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MainInfo> {
        return NSFetchRequest<MainInfo>(entityName: "MainInfo")
    }

    @NSManaged public var country: String
    @NSManaged public var date: Date
    @NSManaged public var id: Int64
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String
    @NSManaged public var bottomWeather: BottomBar?
    @NSManaged public var topWeather: TopBar?
    @NSManaged public var hourlyWeather: NSOrderedSet?
    @NSManaged public var weeklyWeather: NSOrderedSet?

}

// MARK: Generated accessors for hourlyWeather
extension MainInfo {

    @objc(insertObject:inHourlyWeatherAtIndex:)
    @NSManaged public func insertIntoHourlyWeather(_ value: Hourly, at idx: Int)

    @objc(removeObjectFromHourlyWeatherAtIndex:)
    @NSManaged public func removeFromHourlyWeather(at idx: Int)

    @objc(insertHourlyWeather:atIndexes:)
    @NSManaged public func insertIntoHourlyWeather(_ values: [Hourly], at indexes: NSIndexSet)

    @objc(removeHourlyWeatherAtIndexes:)
    @NSManaged public func removeFromHourlyWeather(at indexes: NSIndexSet)

    @objc(replaceObjectInHourlyWeatherAtIndex:withObject:)
    @NSManaged public func replaceHourlyWeather(at idx: Int, with value: Hourly)

    @objc(replaceHourlyWeatherAtIndexes:withHourlyWeather:)
    @NSManaged public func replaceHourlyWeather(at indexes: NSIndexSet, with values: [Hourly])

    @objc(addHourlyWeatherObject:)
    @NSManaged public func addToHourlyWeather(_ value: Hourly)

    @objc(removeHourlyWeatherObject:)
    @NSManaged public func removeFromHourlyWeather(_ value: Hourly)

    @objc(addHourlyWeather:)
    @NSManaged public func addToHourlyWeather(_ values: NSOrderedSet)

    @objc(removeHourlyWeather:)
    @NSManaged public func removeFromHourlyWeather(_ values: NSOrderedSet)

}

// MARK: Generated accessors for weeklyWeather
extension MainInfo {

    @objc(insertObject:inWeeklyWeatherAtIndex:)
    @NSManaged public func insertIntoWeeklyWeather(_ value: Weekly, at idx: Int)

    @objc(removeObjectFromWeeklyWeatherAtIndex:)
    @NSManaged public func removeFromWeeklyWeather(at idx: Int)

    @objc(insertWeeklyWeather:atIndexes:)
    @NSManaged public func insertIntoWeeklyWeather(_ values: [Weekly], at indexes: NSIndexSet)

    @objc(removeWeeklyWeatherAtIndexes:)
    @NSManaged public func removeFromWeeklyWeather(at indexes: NSIndexSet)

    @objc(replaceObjectInWeeklyWeatherAtIndex:withObject:)
    @NSManaged public func replaceWeeklyWeather(at idx: Int, with value: Weekly)

    @objc(replaceWeeklyWeatherAtIndexes:withWeeklyWeather:)
    @NSManaged public func replaceWeeklyWeather(at indexes: NSIndexSet, with values: [Weekly])

    @objc(addWeeklyWeatherObject:)
    @NSManaged public func addToWeeklyWeather(_ value: Weekly)

    @objc(removeWeeklyWeatherObject:)
    @NSManaged public func removeFromWeeklyWeather(_ value: Weekly)

    @objc(addWeeklyWeather:)
    @NSManaged public func addToWeeklyWeather(_ values: NSOrderedSet)

    @objc(removeWeeklyWeather:)
    @NSManaged public func removeFromWeeklyWeather(_ values: NSOrderedSet)

}

extension MainInfo : Identifiable {

}
