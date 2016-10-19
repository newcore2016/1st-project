//
//  ModeType+CoreDataProperties.swift
//  firstProject
//
//  Created by Tri on 10/19/16.
//  Copyright © 2016 efode. All rights reserved.
//

import Foundation
import CoreData


extension ModeType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModeType> {
        return NSFetchRequest<ModeType>(entityName: "ModeType");
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
