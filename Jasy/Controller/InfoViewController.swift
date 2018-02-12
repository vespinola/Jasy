//
//  InfoViewController.swift
//  Jasy
//
//  Created by user on 2/12/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    var apod: ApodModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    class func show(in viewController: CustomViewController, apod: ApodModel, callback: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let apodDetailViewController = storyboard.instantiateViewController(withIdentifier: "ApodDetailViewControllerID") as! ApodDetailViewController
       
    }

}
