//
//  PostViewCell.swift
//  UI_Project
//
//  Created by Shisetsu on 30.07.2021.
//

import UIKit

class PostViewCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var newsPhoto: UIImageView!
    @IBOutlet weak var newsText: UITextView!
    
    
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commensCount: UILabel!
    @IBOutlet weak var repostsCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }

}
