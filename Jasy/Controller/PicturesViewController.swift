//
//  PicturesViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/8/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class PicturesViewController: CustomViewController {
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerTextField: UITextField!
    
    let datePickerView: MonthYearPickerView = {
        let datePickerView: MonthYearPickerView = MonthYearPickerView()
        datePickerView.onDateSelected = { (mont: Int, year: Int) in
            
        }
        return datePickerView
    }()
    
    var apods: [Apod] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = JColor.black
        view.backgroundColor = JColor.background
        
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let now = Date()
        title = "\(now.monthName!) Apods"

        if UserDefaults.standard.string(forKey: JUserDefaultsKeys.currentMonth) == nil {
            UserDefaults.standard.set(now.monthName!, forKey: JUserDefaultsKeys.currentMonth)
        }
        
        refreshMonthPicturesIfIsNeeded()
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Apod")
        fr.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: AppDelegate.stack!.context, sectionNameKeyPath: nil, cacheName: nil)
        
        if let apods = fetchedResultsController?.fetchedObjects as? [Apod] {
            
            if apods.isEmpty {
                getPhotosOfTheDay()
            } else {
                self.apods = apods
            }
            
        }
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:JColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        datePickerTextField.inputAccessoryView = toolbar
        datePickerTextField.inputView = datePickerView
        
    }
    
    func getPhotosOfTheDay() {
        NasaHandler.shared().getPhotoOfTheDays(in: self) {  apodsModel in
            self.apods = apodsModel.map { apodModel in
                let apod = Apod(apod: apodModel, context: AppDelegate.stack!.context)
                return apod
            }
            
            AppDelegate.stack?.save()
            
            performUIUpdatesOnMain {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func refreshButtonOnTap(_ sender: Any) {
        if let photos = fetchedResultsController?.fetchedObjects as? [Apod] {
            for photo in photos {
                AppDelegate.stack?.context.delete(photo)
            }
        }
        
        getPhotosOfTheDay()
    }
    
    
    @IBAction func searchButtonOnTap(_ sender: Any) {
        datePickerTextField.becomeFirstResponder()
    }
    
}


extension PicturesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?.first?.numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.pictureCellID.identifier, for: indexPath) as! PictureCollectionViewCell
        
        let currentApod = apods[indexPath.row]
        
        if let image = currentApod.image {
            cell.picture.image = UIImage(data: image as Data)
        } else if var link = currentApod.url, let type = currentApod.mediaType {
            
            if type == "video" {
                link = Util.getYoutubeVideoThumbnail(for: link)
            }
            
            Util.downloadImageFrom(link: link, in: self) { image in
                currentApod.image = image as NSData
                
                performUIUpdatesOnMain {
                    cell.picture.image = UIImage(data: image)
                }
                
                AppDelegate.stack?.save()
            }
            
        }
        
        cell.titleLabel.text = currentApod.title
        cell.dateLabel.text = currentApod.date
        
        return cell
    }
}

extension PicturesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let apodDetailViewController =  R.storyboard.main.apodDetailViewControllerID()!
        apodDetailViewController.apod = apods[indexPath.row]
        
        Analytics.logEvent("go_to_apod_detail", parameters: nil)
        
        self.navigationController?.pushViewController(apodDetailViewController, animated: true)
        
    }
}

extension PicturesViewController {
    //MARK: Helpers
    
    func refreshMonthPicturesIfIsNeeded () {
        let userDefaults = UserDefaults.standard
        
        let month = userDefaults.string(forKey: JUserDefaultsKeys.currentMonth)
        let currentMonth = Date().monthName
        
        
        if month != currentMonth {
            userDefaults.set(currentMonth, forKey: JUserDefaultsKeys.currentMonth)
            //todo: drop all pictures
            
            if let photos = fetchedResultsController?.fetchedObjects as? [Apod] {
                for photo in photos {
                    AppDelegate.stack?.context.delete(photo)
                }
            }
            
            AppDelegate.stack?.save()
        }
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
//        datePickerTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
