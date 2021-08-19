//
//  PhotoViewCell.swift
//  UI_Project
//
//  Created by Shisetsu on 17.08.2021.
//

import UIKit

class PhotoViewCell: UITableViewCell {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    lazy var profilePhoto: UIImageView = {
        let avatarImage = UIImageView(frame: CGRect(x: 5, y: 5,
                                                    width: 50,
                                                    height: 50))
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        return avatarImage
    }()
    
    lazy var profileName: UILabel = {
        let screenWidth = screenSize.width
        let groupName = UILabel(frame: CGRect(x: 65, y: 10,
                                               width: screenWidth - 85,
                                               height: 20))
        groupName.lineBreakMode = .byWordWrapping
        groupName.numberOfLines = 2
        groupName.textColor = UIColor(red: 43/255, green: 88/255, blue: 132/255, alpha: 1.0)
        groupName.font = UIFont.boldSystemFont(ofSize: 18)
        return groupName
    }()
    
    lazy var date: UILabel = {
        let date = UILabel(frame: CGRect(x: 65, y: profileName.frame.maxY,
                                         width: 200,
                                         height: 20))
        date.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return date
    }()
    
    lazy var newsPhoto: UIImageView = {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let newsPhoto = ScaledHeightImageView(frame: CGRect(x: 5, y: profilePhoto.frame.maxY + 5,
                                                    width: screenWidth - 10,
                                                    height: screenHeight / 3))
        newsPhoto.contentMode = .scaleAspectFit
        newsPhoto.clipsToBounds = true
        newsPhoto.layer.cornerRadius = newsPhoto.frame.height / 15
        return newsPhoto
    }()
    
    lazy var countsPhotoView: UIView = {
        let screenWidth = screenSize.width
        countsPhotoView = UIView(frame: CGRect(x: 5,
                                               y: 5 + profileName.frame.height + date.frame.height + newsPhoto.frame.height + 5,
                                               width: screenWidth - 11,
                                               height: 50))
        return countsPhotoView
    }()
    
    lazy var likesImage: UIImageView = {
        let likesImage = UIImageView(frame: CGRect(x: countsPhotoView.frame.minX,
                                                   y: countsPhotoView.frame.height - 38,
                                                   width: 33,
                                                   height: 27))
        likesImage.image = UIImage(systemName: "heart")
        likesImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return likesImage
    }()
    
    lazy var likesCount: UILabel = {
        let likesCount = UILabel(frame: CGRect(x: likesImage.frame.maxX + 5, y: countsPhotoView.frame.height - 38,
                                               width: 50,
                                               height: 25))
        likesCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return likesCount
    }()
    
    lazy var commentsImage: UIImageView = {
        let commentsImage = UIImageView(frame: CGRect(x: likesCount.frame.maxX + 5, y: countsPhotoView.frame.height - 38,
                                               width: 33,
                                               height: 27))
        commentsImage.image = UIImage(systemName: "message")
        commentsImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return commentsImage
    }()
    

    lazy var commentsCount: UILabel = {
        let commentsCount = UILabel(frame: CGRect(x: commentsImage.frame.maxX + 5, y: countsPhotoView.frame.height - 38,
                                               width: 50,
                                               height: 25))
        commentsCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return commentsCount
    }()
    
    lazy var repostsImage: UIImageView = {
        let repostsImage = UIImageView(frame: CGRect(x: commentsCount.frame.maxX, y: countsPhotoView.frame.height - 38,
                                               width: 33,
                                               height: 27))
        repostsImage.image = UIImage(systemName: "arrowshape.turn.up.forward")
        repostsImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return repostsImage
    }()

    lazy var repostsCount: UILabel = {
        let repostsCount = UILabel(frame: CGRect(x: repostsImage.frame.maxX + 5, y: countsPhotoView.frame.height - 38,
                                               width: 50,
                                               height: 25))
        repostsCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return repostsCount
    }()
    
    lazy var viewsCount: UILabel = {
        let viewsCount = UILabel(frame: CGRect(x: countsPhotoView.frame.maxX - 60, y: countsPhotoView.frame.height - 38,
                                               width: 50,
                                               height: 25))
        viewsCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return viewsCount
    }()
    
    lazy var viewsImage: UIImageView = {
        let viewsImage = UIImageView(frame: CGRect(x: viewsCount.frame.minX - 25, y: countsPhotoView.frame.height - 32,
                                               width: 21,
                                               height: 15))
        viewsImage.image = UIImage(systemName: "eye")
        viewsImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return viewsImage
    }()
    
//    lazy var likesCount: UILabel = {
//        let likesCount = UILabel(frame: CGRect(x: countsPhotoView.frame.minX + 10,
//                                               y: countsPhotoView.frame.height - 38,
//                                               width: 50,
//                                               height: 25))
//        return likesCount
//    }()
//
//    lazy var commentsCount: UILabel = {
//        let commentsCount = UILabel(frame: CGRect(x: countsPhotoView.frame.minX + 70,
//                                                  y: countsPhotoView.frame.height - 38,
//                                                  width: 50,
//                                                  height: 25))
//        return commentsCount
//    }()
//
//    lazy var repostsCount: UILabel = {
//        let repostsCount = UILabel(frame: CGRect(x: countsPhotoView.frame.minX + 130,
//                                                 y: countsPhotoView.frame.height - 38,
//                                                 width: 50,
//                                                 height: 25))
//        return repostsCount
//    }()
//
//    lazy var viewsCount: UILabel = {
//        let viewsCount = UILabel(frame: CGRect(x: countsPhotoView.frame.maxX - 60,
//                                               y: countsPhotoView.frame.height - 38,
//                                               width: 50,
//                                               height: 25))
//        return viewsCount
//    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(profilePhoto)
        addSubview(profileName)
        addSubview(newsPhoto)
        addSubview(date)
        addSubview(countsPhotoView)
        countsPhotoView.addSubview(likesCount)
        countsPhotoView.addSubview(likesImage)
        countsPhotoView.addSubview(commentsCount)
        countsPhotoView.addSubview(commentsImage)
        countsPhotoView.addSubview(repostsCount)
        countsPhotoView.addSubview(repostsImage)
        countsPhotoView.addSubview(viewsCount)
        countsPhotoView.addSubview(viewsImage)
    }
}
