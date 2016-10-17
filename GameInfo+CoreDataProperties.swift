//
//  GameInfo+CoreDataProperties.swift
//  firstProject
//
//  Created by Tri on 10/17/16.
//  Copyright © 2016 efode. All rights reserved.
//

import Foundation
import CoreData


extension GameInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameInfo> {
        return NSFetchRequest<GameInfo>(entityName: "GameInfo");
    }

    @NSManaged public var imageId: Int64
    @NSManaged public var level: Int64
    @NSManaged public var mode: Int64
    @NSManaged public var point: Int64
    @NSManaged public var move: Int64
    @NSManaged public var time: Int64

}
