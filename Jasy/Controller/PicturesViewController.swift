//
//  PicturesViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/8/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

class PicturesViewController: UIViewController {
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
    
    override func viewDidLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !ApodModel.apods.isEmpty {
            apods = ApodModel.apods
            performUIUpdatesOnMain {
                self.collectionView.reloadData()
            }
        } else {
            NasaHandler.shared().getPhotoOfTheDays(in: self) {  apods in
                ApodModel.apods = apods
                self.apods = apods
                
                performUIUpdatesOnMain {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}


extension PicturesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return fetchedResultsController?.sections?.first?.numberOfObjects ?? 0
        return apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCellID", for: indexPath) as! PictureCollectionViewCell
        
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}
