//
//  InfoViewController.swift
//  Jasy
//
//  Created by user on 2/12/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    
    let backgroundAlpha: CGFloat = 0.6
    var apod: ApodModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttributedString = NSMutableAttributedString()
        
        let leftAlignmentStype = NSMutableParagraphStyle()
        leftAlignmentStype.alignment = .left
        
        let centerAlignmentStype = NSMutableParagraphStyle()
        centerAlignmentStype.alignment = .center
        
        titleAttributedString.append(NSMutableAttributedString(string: apod.title!, attributes: [
            NSAttributedStringKey.font             : Constants.Font.ExtraLargeBold,
            NSAttributedStringKey.foregroundColor  : Constants.Color.black,
            NSAttributedStringKey.paragraphStyle   : centerAlignmentStype
        ]))
        
        titleAttributedString.append(NSMutableAttributedString(string: "\n\n\(apod.explanation!)", attributes: [
            NSAttributedStringKey.font             : Constants.Font.Medium,
            NSAttributedStringKey.foregroundColor  : Constants.Color.black,
            NSAttributedStringKey.paragraphStyle   : leftAlignmentStype
        ]))
        
        textView.attributedText = titleAttributedString
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = Constants.Metric.cornerRadius
        textView.textContainerInset = UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20)
        textView.contentOffset = CGPoint.zero
        
        textView.backgroundColor =  Constants.Color.white.withAlphaComponent(backgroundAlpha)
        view.backgroundColor = Constants.Color.translucent
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    class func show(in viewController: UIViewController, apod: ApodModel, callback: (() -> Void)? = nil) {
        let apodDetailViewController = R.storyboard.main.infoViewControllerID()!
        
        apodDetailViewController.apod = apod
        
        apodDetailViewController.providesPresentationContextTransitionStyle = true
        apodDetailViewController.definesPresentationContext = true
        apodDetailViewController.modalPresentationStyle = .overFullScreen
        viewController.present(apodDetailViewController, animated: true, completion: nil)
    }

}
