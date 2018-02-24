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
import SnapKit

class ApodDetailViewController: CustomViewController {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var webView: WKWebView!
    
    var shouldUpdateConstraints = true
    
    var explanationButton: UIButton!
    
    
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
        
        if let hdimage = apod.hdimage {
            performUIUpdatesOnMain {
                self.picture.image = UIImage(data: hdimage as Data)
            }
        } else if let hdurl = apod.hdurl {
            showActivityIndicator()
            
            Util.downloadImageFrom(link: hdurl, in: self) { image in
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
        
        explanationButton = UIButton(type: .infoLight)
        explanationButton.tintColor = .white
        view.addSubview(explanationButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard webView != nil else { return }
        webView.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        explanationButton.addTarget(self, action: #selector(infoButtonOnTap(_:)), for: .touchUpInside)
    }
    
    @IBAction func infoButtonOnTap(_ sender: Any) {
        Analytics.logEvent("show_apod_info", parameters: nil)
        InfoViewController.show(in: self, apod: apod)
    }
    
    override func updateViewConstraints() {
        if shouldUpdateConstraints {
            shouldUpdateConstraints = false
            
            explanationButton.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 30, height: 30))
                $0.bottom.right.equalToSuperview().offset(-16)
            }
        }
        
        super.updateViewConstraints()
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



