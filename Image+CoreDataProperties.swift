//
//  Image+CoreDataProperties.swift
//  firstProject
//
//  Created by Tri on 10/17/16.
//  Copyright © 2016 efode. All rights reserved.
//

import Foundation
import CoreData

extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var fileName: String?
    @NSManaged public var catalogueID: Int64
    @NSManaged public var isUnlock: Bool
    @NSManaged public var toCatalogue: Catalogue?

}
