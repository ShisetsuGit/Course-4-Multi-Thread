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
                    print(changes)
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
                    print(changes)
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
//        return news!.count
        return news!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath)  as! NewsViewCell
        
        let news = news![indexPath.row]
        
        groups = self.newsGroupsDB.readById(id: news.sourceId)
        
        print("groups")
        print(groups)
        
        cell.groupName.text = groups[0].name
        imageCache(url: groups[0].photo50!) { image in
            cell.groupAvatar.image = image
        }
        cell.newsText.text = news.text
        cell.likes.text = "\(news.likes)"
        cell.reposts.text = "\(news.reposts)"
        cell.views.text = "\(news.views)"
        cell.comments.text = "\(news.comments)"
        
        imageCache(url: news.photo!) { image in
            cell.newsPhoto.image = image
        }
        
        
        cell.newsPhoto.contentMode = .scaleToFill
        cell.groupAvatar.clipsToBounds = true
        cell.groupAvatar.layer.cornerRadius = cell.groupAvatar.frame.height / 2

        return cell
    }

}
