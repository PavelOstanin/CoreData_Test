//
//  Brewery+CoreDataProperties.swift
//  CoreData_Test
//
//  Created by Pavel on 02.04.2018.
//  Copyright © 2018 Pavel. All rights reserved.
//

import Foundation
import CoreData

extension Brewery {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Brewery> {
        return NSFetchRequest<Brewery>(entityName: "Brewery")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var logoURL: String?
}
