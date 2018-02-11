//
//  Apod+CoreDataClass.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/11/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Apod)
public class Apod: NSManagedObject {
    // An EntityDescription is an object that has access to all
    // the information you provided in the Entity part of the model
    // you need it to create an instance of this class.
    
    convenience init(apod: ApodModel, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Apod", in: context) {
            self.init(entity: ent, insertInto: context)
            self.date = apod.date
            self.explanation = apod.explanation
            self.hdurl = apod.hdurl
            self.mediaType = apod.mediaType
            self.serviceVersion = apod.serviceVersion
            self.title = apod.title
            self.url = apod.url
            self.copyright = apod.copyright
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
}
