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

class CustomViewController: UIViewController, NVActivityIndicatorViewable {
    
    let alphaPercentage: CGFloat = 0.7
    var activityIndicator: NVActivityIndicatorView? = nil
    var cover: UIView? = nil
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
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
    
    func showActivityIndicator() {
        performUIUpdatesOnMain {
            self.startAnimating(CGSize(width: 40, height: 40), type: .ballTrianglePath, color: JColor.background, backgroundColor: JColor.black.withAlphaComponent(0.7), textColor: JColor.white)
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Wait a moment, please...")
            
        }
        
    }
    
    func hideActivityIndicator() {
        performUIUpdatesOnMain {
            self.stopAnimating()
        }
    }

}

extension CustomViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)")
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
