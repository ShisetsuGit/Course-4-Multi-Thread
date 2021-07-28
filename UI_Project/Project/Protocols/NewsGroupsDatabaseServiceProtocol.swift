//
//  NewsGroupsDatabaseServiceProtocol.swift
//  UI_Project
//
//  Created by Shisetsu on 15.07.2021.
//

import Foundation
import RealmSwift

protocol NewsGroupsDatabaseServiceProtocol {
    func add(newsGroups: [NewsGroupsModel])
    func read() -> [NewsGroupsModel]
    func readById(id: Int) -> [NewsGroupsModel]
    func delete(newsGroups: NewsGroupsModel)
    func readResults() -> Results<NewsGroupsModel>?
}
