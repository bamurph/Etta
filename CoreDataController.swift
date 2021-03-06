//
//  CoreDataController.swift
//  Etta
//
//  Created by Ben Murphy on 8/29/16. 
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Etta")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    /// Save record of a search query
    ///
    /// - parameter query: the search query (completed) to save
    func saveRecord(of query: SearchQuery) {
        // Create and save a record with CD
        let record = Record(context: persistentContainer.viewContext)
        record.result = query.result
        record.term = query.term.trim()
        record.created = NSDate.init()
        saveContext()
    }


    // MARK: - Core Data Fetching 

    func findRecords() throws -> [Record] {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [dateSort]
        do {
            let searchResults = try persistentContainer.viewContext.fetch(request)
            return searchResults
        } catch {
            print("Error with request: \(error)")
            throw error
        }
    }

    func favorites() throws -> [Record] {
        do {
            let records = try findRecords()
            return records
                .filter { $0.favorite == true }
                .sorted { $0.0.term! < $0.1.term! }
        } catch {
            print("error with request: \(error)")
            throw error
        }
    }

    func update(record: Record) throws {
        print("updating record!")
        record.setValue(NSDate.init(), forKey: "created")
        do {
            try persistentContainer.viewContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
}


