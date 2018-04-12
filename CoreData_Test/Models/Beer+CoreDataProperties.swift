//
//  Beer+CoreDataProperties.swift
//  CoreData_Test
//
//  Created by Pavel on 23.03.18.
//  Copyright © 2018 Pavel. All rights reserved.
//

import Foundation
import CoreData

extension Beer {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Beer> {
        return NSFetchRequest<Beer>(entityName: "Beer")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var breweryId: String?
    @NSManaged public var name: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var iconURL: String?
    @NSManaged public var imageURL: String?
    
}
