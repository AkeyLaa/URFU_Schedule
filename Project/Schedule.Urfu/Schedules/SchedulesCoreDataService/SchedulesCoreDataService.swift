//
//  SchedulesCoreDataService.swift
//  Schedule.Urfu
//
//  Created by Sergey on 05/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SchedulesCoreDataServiceDelegate: class {
    func didFinishSavingSchedules(_ sender: SchedulesCoreDataService)
}

class SchedulesCoreDataService {
    
    let appDelegate = AppDelegate()
    weak var dataDelegate: SchedulesCoreDataServiceDelegate?
    
    func saveSchedule(schedules: [ScheduleData]) {
        let context = appDelegate.coreDataStack.mainContext
        let entity = NSEntityDescription.entity(forEntityName: "Schedule", in: context)
        
        for item in schedules {
            do {
                try scheduleFetchedResultsController.performFetch()
            }
            catch {
                print("Error: \(error)\nCould not fetch Core Data context.")
            }
            if (scheduleFetchedResultsController.fetchedObjects!.contains(where: { (s1: Schedule) -> Bool in
                let res = (s1.date == item.date)
                if res {
                    s1.lessons = item.lessons
                    s1.cabinet = item.cabinet
                    s1.teacher = item.teacher
                }
                return res
            })) {
                continue
            } else {
                let newSchedule = NSManagedObject(entity: entity!, insertInto: context)
                newSchedule.setValue(item.date, forKey: "date")
                newSchedule.setValue(item.cabinet, forKey: "cabinet")
                newSchedule.setValue(item.teacher, forKey: "teacher")
                newSchedule.setValue(item.lessons, forKey: "lessons")
            }
        }
        if context.hasChanges {
            do {
                try context.save()
                appDelegate.coreDataStack.saveContext()
            } catch {
                print("Error: \(error)\nCould not save Core Data context.")
            }
        }
        
    }
    
    lazy var scheduleFetchedResultsController: NSFetchedResultsController<Schedule> = {
        let managedContext = appDelegate.coreDataStack.mainContext
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<Schedule>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    func deleteSchedules() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        do {
            let result = try appDelegate.coreDataStack.mainContext.execute(deleteRequest) as? NSBatchDeleteResult
            guard let objectIDs = result?.result as? [NSManagedObjectID] else { return }
            let changes = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [appDelegate.coreDataStack.mainContext])
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
    func didSaveSchedules() {
        dataDelegate?.didFinishSavingSchedules(self)
    }
}
