//
//  Schedule+CoreDataProperties.swift
//  SecApp
//
//  Created by Sergey on 30/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//
//

import Foundation
import CoreData


extension Schedule {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var date: Date?
    @NSManaged public var lessons: [String]?
    @NSManaged public var cabinet: [String]?
    @NSManaged public var teacher: [String]?
    @NSManaged public var group: Group?

}
