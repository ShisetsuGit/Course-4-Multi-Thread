//
//  NewsTableController.swift
//  UI_Project
//
//  Created by  Shisetsu on 22.12.2020.
//

import UIKit
import RealmSwift
import Kingfisher

class NewsTableController: UITableViewController {
    let newsRequest = APIRequest()
    let newsDB = NewsDatabaseService()
    let newsGroupsDB = NewsGroupsDatabaseService()
    var newsToken: NotificationToken?
    var newsGroupsToken: NotificationToken?
    
    var groups = [NewsGroupsModel]()
    
    var news: Results<NewsModel>?{
        didSet {
            newsToken = news!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    print("INITIAL")
                    tableView.reloadData()
                case .update:
                    tableView.reloadData()
                case .error(let error):
                    print("ERROR")
                    fatalError("\(error)")
                }
            }
        }
    }
    var newsGroups: Results<NewsGroupsModel>?{
        didSet {
            newsGroupsToken = newsGroups!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    print("INITIAL")
                    tableView.reloadData()
                case .update:
                    tableView.reloadData()
                case .error(let error):
                    print("ERROR")
                    fatalError("\(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsRequest.getNews()
        news = newsDB.readResults()
        newsGroups = newsGroupsDB.readResults()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newsData = news![indexPath.row]
        groups = self.newsGroupsDB.readById(id: newsData.sourceId)
        
        var cellID = String()
        
        if newsData.text == "" {
            cellID = "photoCell"
        } else {
            cellID = "postCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(cellID)", for: indexPath)  as! PostViewCell

        cell.profileName.text = groups[0].name
        imageCache(url: groups[0].photo50!) { image in
            cell.profilePhoto.image = image
        }
        
        UNIXTime(unixDate: newsData.date) { date in
            cell.date.text = date
        }
        
        cell.profilePhoto.clipsToBounds = true
        cell.profilePhoto.layer.cornerRadius = cell.profilePhoto.frame.height / 2
        
        imageCache(url: newsData.photo!) { image in
            cell.newsPhoto.image = image
        }
        cell.newsPhoto.contentMode = .scaleToFill
        
        if cellID == "postCell" {
            cell.newsText.text = newsData.text
        }
        
        formatCounts(Double(newsData.views)) { views in
            cell.viewsCount.text = views
        }
        formatCounts(Double(newsData.likes)) { likes in
            cell.likesCount.text = likes
        }
        formatCounts(Double(newsData.reposts)) { reposts in
            cell.repostsCount.text = reposts
        }
        formatCounts(Double(newsData.comments)) { comments in
            cell.commensCount.text = comments
        }
        
        return cell
    }
}

