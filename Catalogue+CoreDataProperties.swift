//
//  Catalogue+CoreDataProperties.swift
//  firstProject
//
//  Created by Tri on 10/17/16.
//  Copyright © 2016 efode. All rights reserved.
//

import Foundation
import CoreData

extension Catalogue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catalogue> {
        return NSFetchRequest<Catalogue>(entityName: "Catalogue");
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var details: String?
    @NSManaged public var toImage: NSSet?

}

// MARK: Generated accessors for toImage
extension Catalogue {

    @objc(addToImageObject:)
    @NSManaged public func addToToImage(_ value: Image)

    @objc(removeToImageObject:)
    @NSManaged public func removeFromToImage(_ value: Image)

    @objc(addToImage:)
    @NSManaged public func addToToImage(_ values: NSSet)

    @objc(removeToImage:)
    @NSManaged public func removeFromToImage(_ values: NSSet)

}
