//
//  NewsDatabaseServiceProtocol.swift
//  UI_Project
//
//  Created by Shisetsu on 15.07.2021.
//

import Foundation
import RealmSwift

protocol NewsDatabaseServiceProtocol {
    func add(news: [NewsModel])
    func read() -> [NewsModel]
    func getID(id: Int) -> [NewsModel]
    func delete(news: NewsModel)
    func readResults() -> Results<NewsModel>?
}
