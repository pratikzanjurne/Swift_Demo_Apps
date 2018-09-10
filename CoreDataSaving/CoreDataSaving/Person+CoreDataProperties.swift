//
//  Person+CoreDataProperties.swift
//  CoreDataSaving
//
//  Created by BridgeLabz Solutions LLP  on 8/13/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}
