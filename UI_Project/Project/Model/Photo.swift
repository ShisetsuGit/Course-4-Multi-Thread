//
//  Photo.swift
//  UI_Project
//
//  Created by  Shisetsu on 20.02.2021.

import Foundation
import RealmSwift

// MARK: - Photo
class Photo: Codable {
    var response: Response3
}

// MARK: - Response
class Response3: Codable {
    let count: Int
    var items: [Item3]

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case items = "items"
    }
}

// MARK: - Item
class Item3: Codable {
    var albumID: Int
    let date: Int
    let id: Int
    let ownerID: Int
    let hasTags: Bool
    let postID: Int
    var sizes: [Size]
    let text: String

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date = "date"
        case id = "id"
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case postID = "post_id"
        case sizes = "sizes"
        case text = "text"
    }
}

// MARK: - Size
class Size: Object, Codable {
    //@objc dynamic var ownerID = 0
    @objc dynamic var url = ""
    @objc dynamic var type = ""
    
    override static func primaryKey() -> String? {
        return "url"
    }
}

//// MARK: - Size
//struct Size: Codable {
//    let height: Int
//    let url: String
//    let type: String
//    let width: Int
//
//    enum CodingKeys: String, CodingKey {
//        case height = "height"
//        case url = "url"
//        case type = "type"
//        case width = "width"
//    }
