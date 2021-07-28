//
//  User.swift
//  UI_Project
//
//  Created by  Shisetsu on 16.02.2021.

import Foundation
import RealmSwift

// MARK: - User
class User: Codable {
    var response: Response
}

// MARK: - Response
class Response: Codable {
    var items: [Users]
}

// MARK: - Item
class Users: Object, Codable {
    
    @objc dynamic var firstName = ""
    @objc dynamic var id = 0
    @objc dynamic var lastName = ""
    @objc dynamic var sex = 0
    @objc dynamic var photo = ""
    @objc dynamic var online = 0
    @objc dynamic var bdate: String? = nil
    @objc dynamic var city: City?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case sex
        case photo = "photo_200_orig"
        case online, bdate, city
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - City
class City: Object, Codable {
    @objc dynamic var title = ""
}
