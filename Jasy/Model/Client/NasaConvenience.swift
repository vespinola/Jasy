//
//  NasaConvenience.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/10/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

extension NasaHandler {
    func getPhotoOfTheDays(in viewController: UIViewController, onCompletion: (([ApodModel]) -> Void)? = nil) {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let firstDate = dateFormatter.string(from: date.startOfMonth()!)
        let currentDate = dateFormatter.string(from: date)
        
        let parameters: JDictionary = [
            "start_date" : firstDate,
            "end_date" : currentDate
        ]
        
        NasaHandler.shared().request(verb: .get, parameters: parameters) { data, error in
            guard error == nil else {
                print("nope")
                return
            }
            
            let dictionary = data as! [JDictionary]
            
            let apods = ApodModel.photosFromResults(dictionary)
            
            onCompletion?(apods)
            
        }
        
    }
}
