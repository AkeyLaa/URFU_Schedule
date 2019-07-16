//
//  GroupsCoreDataService.swift
//  Schedule.Urfu
//
//  Created by Sergey on 05/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol GroupsCoreDataServiceDelegate: class{
    func didFinishSavingGroups(_ sender: GroupsCoreDataService)
}

class GroupsCoreDataService {
    
    let appDelegate = AppDelegate()
    
    weak var dataDelegate: GroupsCoreDataServiceDelegate?
    
    func saveGroups(groups: [GroupData]){
        let context = appDelegate.coreDataStack.mainContext
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)
        for item in groups {
            do {
                try groupFetchedResultsController.performFetch()
            }
            catch {
                print("Error: \(error)\nCould not fetch Core Data context.")
            }
            if ((groupFetchedResultsController.fetchedObjects!.contains(where: { (s1: Group) -> Bool in
                return s1.id == String(item.id)
            }))) {
                continue
            } else {
                let newGroup = NSManagedObject(entity: entity!, insertInto: context)
                newGroup.setValue(item.title, forKey: "title")
                newGroup.setValue(String(item.id), forKey: "id")
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
    
    lazy var groupFetchedResultsController: NSFetchedResultsController<Group> = {
        let managedContext = appDelegate.coreDataStack.mainContext
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<Group>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    func deleteGroups() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        print("Groups deleted")
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
    
    func didSaveGroups() {
        dataDelegate?.didFinishSavingGroups(self)
    }
}
