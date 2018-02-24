//
//  NasaConvenience.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/10/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

extension NasaHandler {
    func getPhotoOfTheDays(in viewController: CustomViewController, onCompletion: (([ApodModel]) -> Void)? = nil) {
        let date = Date()
        
        let firstDate = date.startOfMonth()!.formattedDate
        let currentDate = date.formattedDate
        
        let parameters: JDictionary = [
            "start_date" : firstDate,
            "end_date" : currentDate
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
            
            let dictionary = data as! [JDictionary]
            
            let apods = ApodModel.photosFromResults(dictionary)
            
            onCompletion?(apods)
            
        }
    }
    
    func getPhotoOfTheDay(in viewController: CustomViewController, onCompletion: ((ApodModel) -> Void)? = nil) {
        
        viewController.showActivityIndicator()
        
        NasaHandler.shared().request(verb: .get) { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: error?.localizedDescription ?? "Empty Description", in: viewController)
                return
            }
            
            guard let data = data else {
                Util.showAlert(for: "No data returned from server.", in: viewController)
                return
            }
            
            let dictionary = data as! JDictionary
            
            let apod = ApodModel(with: dictionary)
            
            onCompletion?(apod)
            
        }
    }
}
