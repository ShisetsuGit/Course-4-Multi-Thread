//
//  TableViewCell.swift
//  UI_Project
//
//  Created by Shisetsu on 12.12.2020.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    lazy var avatarBackground: UIView = {
        let avatarBackground = UIView(frame: CGRect(x: 6, y: 6,
                                                    width: 48,
                                                    height: 48))
        avatarBackground.backgroundColor = .lightGray
        avatarBackground.layer.cornerRadius = avatarBackground.frame.height / 2
        avatarBackground.layer.shadowOffset = CGSize.zero
        avatarBackground.layer.shadowColor = UIColor.black.cgColor
        avatarBackground.layer.shadowOpacity = 1
        avatarBackground.layer.shadowRadius = 8
        return avatarBackground
    }()
    
    lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(frame: CGRect(x: 6, y: 6,
                                                    width: 48,
                                                    height: 48))
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        return avatarImage
    }()
    
    lazy var friendsName: UILabel = {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let friendsName = UILabel(frame: CGRect(x: 74, y: 20,
                                               width: screenWidth - 84,
                                               height: 20))
        return friendsName
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        addSubview(avatarBackground)
        addSubview(avatarImage)
        addSubview(friendsName)
    }
}

