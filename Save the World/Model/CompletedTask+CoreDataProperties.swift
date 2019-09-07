//
//  CompletedTask+CoreDataProperties.swift
//  
//
//  Created by Michael Ginn on 9/7/19.
//
//

import Foundation
import CoreData


extension CompletedTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompletedTask> {
        return NSFetchRequest<CompletedTask>(entityName: "CompletedTask")
    }

    @NSManaged public var dateCompleted: NSDate?
    @NSManaged public var everyDay: Bool
    @NSManaged public var id: String?
    @NSManaged public var timesCompleted: Int16

}
