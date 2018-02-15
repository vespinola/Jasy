//
//  PicturesViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/8/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

class PicturesViewController: CustomViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var apods: [ApodModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if !ApodModel.apods.isEmpty {
            apods = ApodModel.apods
            performUIUpdatesOnMain {
                self.collectionView.reloadData()
            }
        } else {
            showActivityIndicator()
            
            NasaHandler.shared().getPhotoOfTheDays(in: self) {  apods in
                self.hideActivityIndicator()
                
                ApodModel.apods = apods
                self.apods = apods
                
                performUIUpdatesOnMain {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewDidLayoutSubviews()
    }

}


extension PicturesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return fetchedResultsController?.sections?.first?.numberOfObjects ?? 0
        return apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.pictureCellID.identifier, for: indexPath) as! PictureCollectionViewCell
        
        var currentApod = apods[indexPath.row]
        
        
        if let image = currentApod.image {
            cell.picture.image = UIImage(data: image as Data)
        } else if let link = currentApod.url {

            Util.downloadImageFrom(link: link) { image in
                currentApod.image = image

                performUIUpdatesOnMain {
                    cell.picture.image = UIImage(data: image)
                }
            }
        }
        
        cell.label.text = currentApod.title
        
        return cell
    }
}

extension PicturesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let apodDetailViewController =  R.storyboard.main.apodDetailViewControllerID()!
        apodDetailViewController.apod = apods[indexPath.row]
        
        self.navigationController?.pushViewController(apodDetailViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}
