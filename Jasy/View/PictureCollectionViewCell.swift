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
    
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    var itemWidth = CGFloat.leastNormalMagnitude
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picture.contentMode = .scaleAspectFill
        picture.image = R.image.alienMartian()
        
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = R.image.alienMartian()
    }
}
