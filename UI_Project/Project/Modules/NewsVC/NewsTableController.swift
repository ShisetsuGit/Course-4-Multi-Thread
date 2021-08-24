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
        
        var cell = UITableViewCell()
        
        
        if newsData.text != "" {
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostViewCell
            
            cell1.configurePostCell(newsData: newsData)

            cell = cell1

        } else if newsData.text == "" {

            let cell2 = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
            
            cell2.configurePhotoCell(newsData: newsData)
            
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
