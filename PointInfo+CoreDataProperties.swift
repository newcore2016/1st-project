//
//  PointInfo+CoreDataProperties.swift
//  firstProject
//
//  Created by Tri on 10/17/16.
//  Copyright © 2016 efode. All rights reserved.
//

import Foundation
import CoreData


extension PointInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointInfo> {
        return NSFetchRequest<PointInfo>(entityName: "PointInfo");
    }

    @NSManaged public var totalPoint: Int64
    @NSManaged public var topPoint: Int64
    @NSManaged public var secondPoint: Int64
    @NSManaged public var thirdPoint: Int64

}
