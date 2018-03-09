//
//  NasaConvenience.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/10/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

extension NasaHandler {
    func getPhotoOfTheDays(startDate: String? = nil, endDate: String? = nil, in viewController: CustomViewController, onCompletion: (([ApodModel]) -> Void)? = nil) {
        let date = Date()
        
        var firstDate = date.startOfMonth()!.formattedDate
        var secondDate = date.formattedDate
        
        if let startDate = startDate {
            
            let currentFirstDate = Date(from: startDate)
            
            //This is a special api case. The beginnig.
            if currentFirstDate.month == 6, currentFirstDate.year == 1995 {
                firstDate = "1995-06-16"
            } else {
                firstDate = startDate
            }
            
        }
        
        if let endDate = endDate {
            secondDate = endDate
        }
        
        let parameters: JDictionary = [
            "start_date" : firstDate,
            "end_date" : secondDate
        ]
        
        viewController.showActivityIndicator()
        
        NasaHandler.shared().request(verb: .get, parameters: parameters) { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: error?.localizedDescription ?? "Empty Description", in: viewController)
                return
            }
            
            guard let data = data else {
                Util.showAlert(for: "No data returned from server.", in: viewController)
                return
            }
            
            if let dictionary = data as? [JDictionary] {
                let apods = ApodModel.photosFromResults(dictionary)
                onCompletion?(apods)
            } else if let dictionary = data as? JDictionary, let message = dictionary["msg"] as? String {
                Util.showAlert(for: message, in: viewController)
            }
            
        }
    }
    
}
