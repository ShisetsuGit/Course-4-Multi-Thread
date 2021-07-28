//
//  GroupsDatabaseServiceProtocol.swift
//  UI_Project
//
//  Created by Shisetsu on 06.07.2021.
//

import Foundation
import RealmSwift

protocol GroupsDatabaseServiceProtocol {
    func add(groups: [GroupsModel])
    func read() -> [GroupsModel]
    func delete(groups: GroupsModel)
    func readResults() -> Results<GroupsModel>?
}
