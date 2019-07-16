//
//  Group+CoreDataProperties.swift
//  SecApp
//
//  Created by Sergey on 27/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var schedule: Schedule?

}
