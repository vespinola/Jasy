//
//  Apod.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/10/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

struct ApodModel {
    
    static var apods: [ApodModel] = []
    
    var date: String!
    var explanation: String!
    var hdurl: String?
    var mediaType: String!
    var serviceVersion: String!
    var title: String!
    var url: String!
    var copyright: String?
    
    var image: Data?
    var hdImage: Data?
    
    init(with dictionary :JDictionary) {
        date = dictionary["date"] as! String
        explanation = dictionary["explanation"] as! String
        hdurl = dictionary["hdurl"] as? String
        mediaType = dictionary["media_type"] as! String
        serviceVersion = dictionary["service_version"] as! String
        title = dictionary["title"] as! String
        url = dictionary["url"] as! String
        copyright = dictionary["copyright"] as? String
    }
    
}

extension ApodModel {
    
    static func photosFromResults(_ results: [JDictionary]) -> [ApodModel] {
        
        var apods: [ApodModel] = []
        
        for result in results {
            apods.append(ApodModel(with: result))
        }
        
        return apods
    }
}

extension ApodModel: Equatable {}

func ==(lhs: ApodModel, rhs: ApodModel) -> Bool {
    return lhs.date == rhs.date
}
