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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerTextField: UITextField!
    
    let datePickerView: MonthYearPickerView = {
        let datePickerView: MonthYearPickerView = MonthYearPickerView()
        return datePickerView
    }()
    
    var selectedDate: Date!
    
    var newTitle: String {
        return "Apods - \(selectedDate.monthName!) \(selectedDate.yearString!)"
    }
    
    var apods: [Apod] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = JColor.black
        view.backgroundColor = JColor.background
        
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        if let storedDate = UserDefaults.standard.value(forKey: JUserDefaultsKeys.currentMonth) as? Date {
            selectedDate = storedDate
        } else {
            selectedDate = Date()
        }
        title = newTitle

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
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.backgroundColor = JColor.blue
        toolbar.barStyle = .blackOpaque
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        datePickerTextField.inputAccessoryView = toolbar
        datePickerTextField.inputView = datePickerView
        
        datePickerView.onDateSelected = { (month: Int, year: Int) in
            
            //from https://stackoverflow.com/a/33344575
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = 1
            
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            let someDateTime = userCalendar.date(from: dateComponents)

            self.selectedDate = someDateTime
        }
        
    }
    
    func getPhotosOfTheDay(with firstDate: String? = nil, and secondDate: String? = nil) {
        NasaHandler.shared().getPhotoOfTheDays(startDate: firstDate, endDate: secondDate, in: self) {  apodsModel in
            
            UserDefaults.standard.set(self.selectedDate, forKey: JUserDefaultsKeys.currentMonth)
            
            self.apods = apodsModel.map { apodModel in
                let apod = Apod(apod: apodModel, context: AppDelegate.stack!.context)
                return apod
            }
            
            AppDelegate.stack?.save()
            
            performUIUpdatesOnMain {
                self.title = self.newTitle
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func refreshButtonOnTap(_ sender: Any) {
        selectedDate = Date()
        refreshApods()
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
            cell.hideActivityIndicator()
        } else if var link = currentApod.url, let type = currentApod.mediaType {
            
            cell.titleLabel.isHidden = true
            cell.dateLabel.isHidden = true
            
            if type == "video" {
                link = Util.getYoutubeVideoThumbnail(for: link)
            }
            
            cell.showActivityIndicator()
            
            if type == "video" {
                cell.hideActivityIndicator()
                cell.picture.image = Util.getThumbnailImage(for: link)
                cell.titleLabel.isHidden = false
                cell.dateLabel.isHidden = false
            } else {
                Util.downloadImageFrom(link: link, for: cell.contentView, in: self) { image in
                    cell.hideActivityIndicator()
                    
                    currentApod.image = image as NSData
                    
                    performUIUpdatesOnMain {
                        cell.picture.image = UIImage(data: image)
                        cell.titleLabel.isHidden = false
                        cell.dateLabel.isHidden = false
                    }
                    
                    AppDelegate.stack?.save()
                }
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
        
        navigationController?.pushViewController(apodDetailViewController, animated: true)
        
    }
}

extension PicturesViewController {
    //MARK: Helpers
    @objc func doneDatePicker(){
        
        let date = selectedDate!
        
        let firstDate = date.startOfMonth()
        let endDate = date.endOfMonth()
        refreshApods(with: firstDate?.formattedDate, and: endDate?.formattedDate)
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        view.endEditing(true)
    }
    
    func refreshApods(with firstDate: String? = nil, and secondDate: String? = nil){
        if let photos = fetchedResultsController?.fetchedObjects as? [Apod] {
            for photo in photos {
                AppDelegate.stack?.context.delete(photo)
            }
        }
        
        getPhotosOfTheDay(with: firstDate, and: secondDate)
    }
}
