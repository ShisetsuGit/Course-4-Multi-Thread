//
//  Group.swift
//  UI_Project
//
//  Created by  Shisetsu on 18.02.2021.

import Foundation
import RealmSwift

// MARK: - Group
class Group: Codable {
    var response: Response2
}

// MARK: - Response
class Response2: Codable {
  var items: [Groups]
}

// MARK: - Item
class Groups: Object, Codable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo = "photo_100"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
