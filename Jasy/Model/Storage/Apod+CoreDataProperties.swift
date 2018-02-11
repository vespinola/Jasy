//
//  Apod+CoreDataProperties.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/11/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//
//

import Foundation
import CoreData


extension Apod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Apod> {
        return NSFetchRequest<Apod>(entityName: "Apod")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var mediaType: String?
    @NSManaged public var serviceVersion: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var copyright: String?
    @NSManaged public var image: NSData?
    @NSManaged public var hdimage: NSData?

}
