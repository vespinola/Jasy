//
//  CustomViewController.swift
//  VirtualTourist
//
//  Created by User on 12/26/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import CoreData

class CustomViewController: UIViewController {
    
    let alphaPercentage: CGFloat = 0.7
    
    var activityIndicator: UIActivityIndicatorView!
    
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
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(alphaPercentage)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(activityIndicator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    func showActivityIndicatory() {
        
        performUIUpdatesOnMain {
            self.view.isUserInteractionEnabled = false
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.activityIndicator.startAnimating()
        }
        
    }
    
    func hideActivityIndicator() {
        performUIUpdatesOnMain {
            self.view.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
        }
    }

}

extension CustomViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
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
