//
//  ApodDetailViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/11/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit
import Firebase

class ApodDetailViewController: CustomViewController {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoButton: UIButton!
    
    var hdurl: String!
    var apod: Apod!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = apod.title
        
        picture.contentMode = .scaleAspectFit
        picture.backgroundColor = UIColor.black
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
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
        } else {
            showActivityIndicator()
            
            Util.downloadImageFrom(link: apod.hdurl!) { image in
                self.hideActivityIndicator()
                performUIUpdatesOnMain {
                    self.apod.hdimage = image as NSData
                    self.picture.image = UIImage(data: image)
                }
            }
        }
    
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
