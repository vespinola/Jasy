//
//  Util.swift
//  Jasy
//
//  Created by User on 12/19/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AVFoundation

typealias JDictionary = [String: Any]

enum HTTPMethod {
    case post
    case get
    case put
    case delete
    
    func method() -> String {
        switch self {
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        default:
            return "GET"
        }
    }
}

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

func runIn(seconds: Double, callback: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        callback()
    }
}

class Util {
    
    class func getDate(for dateString: String) -> Date? {
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyy-MM-dd"
        return dateFormatterDate.date(from: dateString)
    }
    
    class func showAlert(for message: String, in viewController: UIViewController, callback: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler:  { _ in
            callback?()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func prepareForJsonBody(_ dictionary: JDictionary) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        return jsonData
    }
    
    class func openURL(with string: String) {
        //from https://stackoverflow.com/a/39546889
        guard let url = URL(string: string) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    class func getThumbnailImage(for link: String) -> UIImage? {
        guard let url = URL(string: link) else { return nil }
        
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    class func downloadImageFrom(link: String, for view: UIView? = nil, in viewController: CustomViewController, callback: ((Data) -> Void)? = nil) {
        
        guard !link.isEmpty else { return }
        
        guard let url = URL(string: link) else { return }
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                
                let error = NSError(domain: "taskForMethod", code: 1, userInfo: userInfo)
                viewController.hideActivityIndicator()
                Util.showAlert(for: error.localizedDescription, in: viewController) {
                    viewController.navigationController?.popViewController(animated: true)
                }
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image")
                else { return }
            
            
            callback?(data)
            
        }.resume()
    }
   
    //from https://stackoverflow.com/a/44039304
    class func getYoutubeVideoThumbnail(for link: String) -> String {
        let regexString: String = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regExp = try? NSRegularExpression(pattern: regexString, options: .caseInsensitive)
        let array: [Any] = (regExp?.matches(in: link, options: [], range: NSRange(location: 0, length: (link.count ))))!
        if array.count > 0 {
            let result: NSTextCheckingResult? = array.first as? NSTextCheckingResult
            let id = (link as NSString).substring(with: (result?.range)!)
            
            return "https://i.ytimg.com/vi/\(id)/maxresdefault.jpg"
        }
        
        return ""
    }
    
    class func share(item: Any, in viewcontroller: UIViewController, onCompletion: (() -> Void)? = nil) {
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewcontroller.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        viewcontroller.present(activityViewController, animated: true, completion: onCompletion)
    }
}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

//from http://ioscake.com/how-to-get-start-date-and-end-date-of-the-current-month-swift-3.html
extension Date {
    
    //from https://stackoverflow.com/a/24777965
    init(from dateString: String, with format: String? = "yyyy-MM-dd") {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        self = date
    }
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
    
    var monthName: String! {
        let names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        let index = Int(dateFormatter.string(from: self))! - 1
        return names[index]
    }
    
    var yearString: String! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var month: Int! {
        let comp: DateComponents = Calendar.current.dateComponents([.month], from: Calendar.current.startOfDay(for: self))
        return comp.month
    }
    
    var year: Int! {
        let comp: DateComponents = Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self))
        return comp.year
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func isInTheSameRange(with date: Date) -> Bool {
        let result = (self.month == date.month) && (self.year == date.year)
        return result
    }
    
}



