//
//  CustomViewController.swift
//  VirtualTourist
//
//  Created by User on 12/26/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import CoreData
import NVActivityIndicatorView

class CustomViewController: UIViewController {
    
    let alphaPercentage: CGFloat = 0.7
    var activityIndicator: NVActivityIndicatorView? = nil
    var cover: UIView? = nil
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            print("COUNT: \(fetchedResultsController?.sections?.first?.numberOfObjects ?? 0)")
            fetchedResultsController?.delegate = self
            executeSearch()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let window = UIApplication.shared.keyWindow!
        cover?.frame = CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height)
        activityIndicator?.center = self.view.center
    }
    
    func showActivityIndicator() {
        performUIUpdatesOnMain {
            let window = UIApplication.shared.keyWindow!
            self.cover = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            self.cover?.backgroundColor = JColor.black.withAlphaComponent(0.6)
            self.cover?.tag = 101
            self.view.addSubview(self.cover!)
            
            self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballTrianglePath, color: JColor.background)
            self.activityIndicator?.center = self.view.center
            self.activityIndicator?.tag = 100
            self.view.addSubview(self.activityIndicator!)
            self.activityIndicator?.startAnimating()
        }
        
    }
    
    func hideActivityIndicator() {
        performUIUpdatesOnMain {
            if let view = self.view.viewWithTag(100) {
                view.removeFromSuperview()
            }
            
            if let view = self.view.viewWithTag(101) {
                view.removeFromSuperview()
            }
        }
    }

}

extension CustomViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                //print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CustomViewController: NSFetchedResultsControllerDelegate  {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {}
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
}
