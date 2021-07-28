//
//  TableViewCellGroups.swift
//  UI_Project
//
//  Created by  Shisetsu on 11.12.2020.
//

import UIKit

class TableViewCellGroups: UITableViewCell {

    @IBOutlet weak var userGroupsLabel: UILabel!
    @IBOutlet weak var userGroupsPhoto: UIImageView!
    
//    @IBOutlet weak var groupDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
