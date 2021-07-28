//
//  TableViewCellRecomendedGroups.swift
//  UI_Project
//
//  Created by  Shisetsu on 11.12.2020.
//

import UIKit

class TableViewCellRecomendedGroups: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var recomendedGroupsLabel: UILabel!
    @IBOutlet weak var recomendedGroupsPhoto: UIImageView!
//    @IBOutlet weak var groupDescription: UILabel!
    
    
}
