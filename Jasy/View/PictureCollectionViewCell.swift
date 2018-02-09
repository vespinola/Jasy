//
//  PictureCollectionViewCell.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/8/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picture.contentMode = .scaleAspectFit
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
    }
}
