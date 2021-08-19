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
    let screenSize: CGRect = UIScreen.main.bounds
    var rowHeight = CGFloat()
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsData = news![indexPath.row]
        if newsData.text != "" {
            rowHeight = 1200
        } else if newsData.text == "" {
            rowHeight = 400
        }
        
        return rowHeight
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
        
        var cell = UITableViewCell()
        
        if newsData.text != "" {
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostViewCell

            cell1.profileName.text = groups[0].name
            imageCache(url: groups[0].photo50!) { image in
                cell1.profilePhoto.image = image
            }
            UNIXTime(unixDate: newsData.date) { date in
                cell1.date.text = date
            }
            imageCache(url: newsData.photo!) { image in
                cell1.newsPhoto.image = image
            }
            PostViewCell().setNews(text: newsData.text!)
            cell1.newsText.text = newsData.text
            formatCounts(Double(newsData.views)) { views in
                cell1.viewsCount.text = views
            }
            formatCounts(Double(newsData.likes)) { likes in
                cell1.likesCount.text = likes
            }
            formatCounts(Double(newsData.reposts)) { reposts in
                cell1.repostsCount.text = reposts
            }
            formatCounts(Double(newsData.comments)) { comments in
                cell1.commentsCount.text = comments
            }

            cell = cell1

        } else if newsData.text == "" {

            let cell2 = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
            
            cell2.profileName.text = groups[0].name
            imageCache(url: groups[0].photo50!) { image in
                cell2.profilePhoto.image = image
            }
            UNIXTime(unixDate: newsData.date) { date in
                cell2.date.text = date
            }
            imageCache(url: newsData.photo!) { image in
                cell2.newsPhoto.image = image
            }
            formatCounts(Double(newsData.views)) { views in
                cell2.viewsCount.text = views
            }
            formatCounts(Double(newsData.likes)) { likes in
                cell2.likesCount.text = likes
            }
            formatCounts(Double(newsData.reposts)) { reposts in
                cell2.repostsCount.text = reposts
            }
            formatCounts(Double(newsData.comments)) { comments in
                cell2.commentsCount.text = comments
            }
            
            cell = cell2
        }
        return cell
    }
}

