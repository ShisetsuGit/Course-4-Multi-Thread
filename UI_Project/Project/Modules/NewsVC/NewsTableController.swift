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
    
    var nextFrom = ""
    var isLoading = false
    
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
        tableView.prefetchDataSource = self
        news = newsDB.readResults()
        newsGroups = newsGroupsDB.readResults()
        setupRefreshControl()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsData = news![indexPath.row]
        var rowHeight = CGFloat()
        if newsData.text != "" {
            rowHeight = 610
        } else if newsData.text == "" {
            rowHeight = 400
        }
        
        return rowHeight
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Загрузка новостей...")
        refreshControl?.tintColor = .lightGray
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        self.refreshControl?.beginRefreshing()

        let mostFreshNewsDate = self.news?[0].date ?? Int(Date().timeIntervalSince1970)
        
        newsRequest.getNews(startTime: Double(mostFreshNewsDate + 1)) { [weak self] next in
            guard let self = self else { return }
            self.nextFrom = next
        }
        self.refreshControl?.endRefreshing()
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
            
            cell1.setNews(text: newsData.text!)
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

extension NewsTableController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        if maxRow > news!.count - 3, !isLoading {
            isLoading = true
            newsRequest.getNews(startFrom: nextFrom) { [weak self] (nextFrom) in
                guard let self = self else { return }
                self.isLoading = false
            }
        }
    }
}
