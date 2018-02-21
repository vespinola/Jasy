//
//  ApodDetailViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/11/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit
import Firebase
import WebKit

class ApodDetailViewController: CustomViewController {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoButton: UIButton!
    var webView: WKWebView!
    
    
    var hdurl: String!
    var apod: Apod!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = apod.title
        
        picture.contentMode = .scaleAspectFit
        picture.backgroundColor = JColor.black
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 7.0
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.black
        
        let origImage = R.image.ic_info_outline()
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        infoButton.setImage(tintedImage, for: .normal)
        infoButton.tintColor = .white
        
        if let hdimage = apod.hdimage {
            performUIUpdatesOnMain {
                self.picture.image = UIImage(data: hdimage as Data)
            }
        } else if let hdurl = apod.hdurl {
            showActivityIndicator()
            
            Util.downloadImageFrom(link: hdurl) { image in
                self.hideActivityIndicator()
                self.apod.hdimage = image as NSData
                performUIUpdatesOnMain {
                    self.picture.image = UIImage(data: image)
                }
                AppDelegate.stack?.save()
            }
        } else {
            let webViewConfiguration = WKWebViewConfiguration()
            webViewConfiguration.allowsInlineMediaPlayback = true
            webView = WKWebView(frame: self.view.frame, configuration: webViewConfiguration)
            webView.backgroundColor = JColor.black
            webView.navigationDelegate = self
            view.addSubview(webView)
            let myURL = URL(string: apod.url!)
            let youtubeRequest = URLRequest(url: myURL!)
            webView.load(youtubeRequest)
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard webView != nil else { return }
        webView.frame = view.frame
    }
    
    @IBAction func infoButtonOnTap(_ sender: Any) {
        Analytics.logEvent("show_apod_info", parameters: nil)
        InfoViewController.show(in: self, apod: apod)
    }
}

extension ApodDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return picture
    }
}

extension ApodDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator()
    }
}



