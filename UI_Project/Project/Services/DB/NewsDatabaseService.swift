//
//  NewsDatabaseService.swift
//  UI_Project
//
//  Created by Shisetsu on 15.07.2021.
//

import Foundation
import RealmSwift

class NewsDatabaseService: NewsDatabaseServiceProtocol {
    
    let config = Realm.Configuration(schemaVersion: 1)
    lazy var realm = try! Realm(configuration: config)
    
    func add(news: [NewsModel]) {
        
        do {
            self.realm.beginWrite()
            self.realm.add(news, update: .modified)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read() -> [NewsModel] {
        let news = self.realm.objects(NewsModel.self)
        return Array(news)
    }
    
    func getID(id: Int) -> [NewsModel] {
        let id = self.realm.objects(NewsModel.self).filter("sourceId = '\(id)'")
        return Array(id)
    }
    
    func readResults() -> Results<NewsModel>? {
        let newsResults = self.realm.objects(NewsModel.self).sorted(byKeyPath: "date", ascending: false)
        return newsResults
    }
    
    func delete(news: NewsModel) {
        
        do {
            self.realm.beginWrite()
            self.realm.delete(news)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
