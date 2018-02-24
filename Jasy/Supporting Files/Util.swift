//
//  Util.swift
//  Jasy
//
//  Created by User on 12/19/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

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
    
    class func showAlert(for message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
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
    
    class func downloadImageFrom(link: String, in viewController: CustomViewController, callback: ((Data) -> Void)? = nil) {
        guard let url = URL(string: link) else { return }
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = JConfig.timeoutInterval
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                
                let error = NSError(domain: "taskForMethod", code: 1, userInfo: userInfo)
                
                Util.showAlert(for: error.localizedDescription, in: viewController)
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

//from: https://stackoverflow.com/a/27712427
extension UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, callback: ((UIImage) -> Void)? = nil) {
//        contentMode = mode
//
//        let session = URLSession.shared
//
//        let request = NSMutableURLRequest(url: url)
//        request.timeoutInterval = JConfig.timeoutInterval
//
//
//        session.dataTask(with: request as URLRequest) { data, response, error in
//
//            func sendError(_ error: String) {
//                let userInfo = [NSLocalizedDescriptionKey : error]
//
////                Util.showAlert(for: error?.localizedDescription ?? "Empty Description", in: viewController)
//            }
//
//            guard (error == nil) else {
//                sendError("There was an error with your request: \(error!.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                sendError("No data was returned by the request!")
//                return
//            }
//
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//
//                let image = UIImage(data: data)
//                else { return }
//
//            performUIUpdatesOnMain {
//                self.image = image
//                callback?(image)
//            }
//        }.resume()
//
////        session.dataTask(with: request) { data, response, error in
////            guard
////                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
////                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
////                let data = data, error == nil,
////                let image = UIImage(data: data)
////                else { return }
////
////            performUIUpdatesOnMain {
////                self.image = image
////                callback?(image)
////            }
////
////        }.resume()
//    }
    
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, callback: ((UIImage) -> Void)? = nil) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode, callback: callback)
//    }
}

//from http://ioscake.com/how-to-get-start-date-and-end-date-of-the-current-month-swift-3.html
extension Date {
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
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}



