//
//  Catalogue+CoreDataProperties.swift
//  firstProject
//
//  Created by Tri on 10/19/16.
//  Copyright © 2016 efode. All rights reserved.
//

import Foundation
import CoreData

extension Catalogue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catalogue> {
        return NSFetchRequest<Catalogue>(entityName: "Catalogue");
    }

    @NSManaged public var details: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var toImage: NSSet?
    @NSManaged public var toPointInfo: NSSet?

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

// MARK: Generated accessors for toPointInfo
extension Catalogue {

    @objc(addToPointInfoObject:)
    @NSManaged public func addToToPointInfo(_ value: PointInfo)

    @objc(removeToPointInfoObject:)
    @NSManaged public func removeFromToPointInfo(_ value: PointInfo)

    @objc(addToPointInfo:)
    @NSManaged public func addToToPointInfo(_ values: NSSet)

    @objc(removeToPointInfo:)
    @NSManaged public func removeFromToPointInfo(_ values: NSSet)

}
