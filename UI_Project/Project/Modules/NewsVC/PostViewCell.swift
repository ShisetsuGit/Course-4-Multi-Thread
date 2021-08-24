//
//  PostViewCell.swift
//  UI_Project
//
//  Created by Shisetsu on 30.07.2021.
//
import UIKit
import RealmSwift

class PostViewCell: UITableViewCell {
    
    let screenSize: CGRect = UIScreen.main.bounds
    var groups = [NewsGroupsModel]()
    let newsGroupsDB = NewsGroupsDatabaseService()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsLabelFrame()
        setCountsPosition()
    }
    
    //MARK: CELL CONFUGIRATION
    
    func configurePostCell(newsData: NewsModel) {
        groups = self.newsGroupsDB.readById(id: newsData.sourceId)
        profileName.text = groups[0].name
        
        imageCache(url: groups[0].photo50!) { [weak self] image in
            self?.profilePhoto.image = image
        }
        UNIXTime(unixDate: newsData.date) { [weak self] date in
            self?.date.text = date
        }
        imageCache(url: newsData.photo!) { [weak self] image in
            self?.newsPhoto.image = image
        }
        
        setNews(text: newsData.text!)
        newsText.text = newsData.text
        
        formatCounts(Double(newsData.views)) { [weak self] views in
            self?.viewsCount.text = views
        }
        formatCounts(Double(newsData.likes)) { [weak self] likes in
            self?.likesCount.text = likes
        }
        formatCounts(Double(newsData.reposts)) { [weak self] reposts in
            self?.repostsCount.text = reposts
        }
        formatCounts(Double(newsData.comments)) { [weak self] comments in
            self?.commentsCount.text = comments
        }
    }
    
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
    
    //MARK: START
    //
    //
    //
    //MARK: Set Positions

    lazy var profilePhoto: UIImageView = {
        let avatarImage = UIImageView(frame: CGRect(x: 5, y: 6,
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
    
    lazy var newsText: UILabel = {
        let newsText = UILabel()
        return newsText
    }()
    
    lazy var countsPostView: UIView = {
        let countsView = UIView()
        return countsView
    }()
    
    lazy var likesImage: UIImageView = {
        let likesImage = UIImageView(frame: CGRect(x: countsPostView.frame.minX + 10, y: countsPostView.frame.minY + 12,
                                               width: 33,
                                               height: 27))
        likesImage.image = UIImage(systemName: "heart")
        likesImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return likesImage
    }()
    
    
    lazy var likesCount: UILabel = {
        let likesCount = UILabel(frame: CGRect(x: likesImage.frame.maxX + 5, y: countsPostView.frame.minY + 13,
                                               width: 50,
                                               height: 25))
        likesCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return likesCount
    }()
    
    lazy var commentsImage: UIImageView = {
        let commentsImage = UIImageView(frame: CGRect(x: likesCount.frame.maxX + 5, y: countsPostView.frame.minY + 12,
                                               width: 33,
                                               height: 27))
        commentsImage.image = UIImage(systemName: "message")
        commentsImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return commentsImage
    }()
    

    lazy var commentsCount: UILabel = {
        let commentsCount = UILabel(frame: CGRect(x: commentsImage.frame.maxX + 5, y: countsPostView.frame.minY + 13,
                                               width: 50,
                                               height: 25))
        commentsCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return commentsCount
    }()
    
    lazy var repostsImage: UIImageView = {
        let repostsImage = UIImageView(frame: CGRect(x: commentsCount.frame.maxX, y: countsPostView.frame.minY + 12,
                                               width: 33,
                                               height: 27))
        repostsImage.image = UIImage(systemName: "arrowshape.turn.up.forward")
        repostsImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return repostsImage
    }()

    lazy var repostsCount: UILabel = {
        let repostsCount = UILabel(frame: CGRect(x: repostsImage.frame.maxX + 5, y: countsPostView.frame.minY + 13,
                                               width: 50,
                                               height: 25))
        repostsCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return repostsCount
    }()
    
    lazy var viewsCount: UILabel = {
        let viewsCount = UILabel(frame: CGRect(x: countsPostView.frame.width + screenSize.width - 60, y: countsPostView.frame.minY + 13,
                                               width: 50,
                                               height: 25))
        viewsCount.textColor = UIColor(red: 98/255, green: 109/255, blue: 122/255, alpha: 1.0)
        return viewsCount
    }()
    
    lazy var viewsImage: UIImageView = {
        let viewsImage = UIImageView(frame: CGRect(x: viewsCount.frame.minX - 25, y: countsPostView.frame.minY + 18,
                                               width: 21,
                                               height: 15))
        viewsImage.image = UIImage(systemName: "eye")
        viewsImage.tintColor = UIColor(red: 169/255, green: 175/255, blue: 186/255, alpha: 1.0)
        return viewsImage
    }()
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let screenWidth = screenSize.width
        let maxWidth = bounds.width + 10
        let textBlock = CGSize(width: maxWidth, height: 200) //CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(Double(screenWidth - 10)), height: ceil(height))
        
        return size
    }
    
    func setCountsPosition() {
        let screenWidth = screenSize.width
        let newsLabelSize = getLabelSize(text: newsText.text!, font: newsText.font)
        countsPostView.frame = CGRect(x: 5,
                                  y: date.frame.maxY + newsPhoto.frame.maxY + 5 + newsLabelSize.height - 45,
                                  width: screenWidth - 11,
                                  height: 50)
        countsPostView.layer.cornerRadius = countsPostView.frame.height / 2
    }
    
    func newsLabelFrame() {
        let newsLabelSize = getLabelSize(text: newsText.text!, font: newsText.font)
        let newsLabelOrigin =  CGPoint(x: 5, y: newsPhoto.frame.maxY + 5)
        newsText.frame = CGRect(origin: newsLabelOrigin, size: newsLabelSize)
        newsText.textAlignment = .left
        newsText.lineBreakMode = .byTruncatingTail
        newsText.numberOfLines = 30
    }
    
    //MARK: STOP
    
    func setNews(text: String) {
        newsText.text = text
        newsLabelFrame()
        setCountsPosition()
    }
    
    private func setupView() {
        addSubview(profilePhoto)
        addSubview(profileName)
        addSubview(newsPhoto)
        addSubview(newsText)
        addSubview(date)
        addSubview(countsPostView)
        countsPostView.addSubview(likesCount)
        countsPostView.addSubview(likesImage)
        countsPostView.addSubview(commentsCount)
        countsPostView.addSubview(commentsImage)
        countsPostView.addSubview(repostsCount)
        countsPostView.addSubview(repostsImage)
        countsPostView.addSubview(viewsCount)
        countsPostView.addSubview(viewsImage)
    }
       

}
