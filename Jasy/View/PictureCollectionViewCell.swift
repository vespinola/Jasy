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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    var itemWidth = CGFloat.leastNormalMagnitude
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        [titleLabel, dateLabel].forEach {
            $0?.lineBreakMode = .byClipping
            $0?.numberOfLines = 0
            $0?.textColor = JColor.white
            $0?.textAlignment = .center
        }
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        dateLabel.font = JFont.verySmall
        titleLabel.font = JFont.smallMedium

        picture.contentMode = .scaleAspectFill
        
        picture.layer.masksToBounds = true
        picture.layer.cornerRadius = JMetric.cornerRadius
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = nil
        titleLabel.isHidden = false
    }
}
