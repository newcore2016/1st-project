//
//  LevelType+CoreDataProperties.swift
//  firstProject
//
//  Created by Tri on 10/17/16.
//  Copyright © 2016 efode. All rights reserved.
//

import Foundation
import CoreData


extension LevelType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LevelType> {
        return NSFetchRequest<LevelType>(entityName: "LevelType");
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var timePerImage: Int64

}
