//
//  Record+CoreDataProperties.swift
//  Etta
//
//  Created by Ben Murphy on 8/29/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record");
    }

    @NSManaged public var term: String?
    @NSManaged public var result: String?
    @NSManaged public var created: NSDate?

}
