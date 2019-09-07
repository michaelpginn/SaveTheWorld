//
//  StickerPlacement+CoreDataProperties.swift
//  
//
//  Created by Michael Ginn on 9/7/19.
//
//

import Foundation
import CoreData


extension StickerPlacement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StickerPlacement> {
        return NSFetchRequest<StickerPlacement>(entityName: "StickerPlacement")
    }

    @NSManaged public var id: String?
    @NSManaged public var x: Double
    @NSManaged public var y: Double

}
