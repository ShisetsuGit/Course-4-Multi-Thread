//
//  FullScreenPhotoCell.swift
//  UI_Project
//
//  Created by  Shisetsu on 01.01.2021.
//

import UIKit

class FullScreenPhotoCell: UICollectionViewCell {

    @IBOutlet weak var fullPhotoView: UIImageView!
    @IBOutlet weak var likeSubView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addSubview(likeSubView)
    }
}
