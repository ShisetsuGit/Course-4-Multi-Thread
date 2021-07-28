//
//  PhotoModel.swift
//  UI_Project
//
//  Created by Shisetsu on 07.07.2021.
//

import Foundation
import DynamicJSON
import RealmSwift

class PhotoModel: Object {

    @objc dynamic var id: String?
    @objc dynamic var url: String?
    @objc dynamic var userLikes = 0
    @objc dynamic var likes = 0
    
    convenience required init(data: JSON) {
        self.init()
        
        self.id = data.owner_id.string
        self.url = data["sizes"][7].url.string
        if self.url == nil {
            self.url = data["sizes"][5].url.string
        }
        self.userLikes = data.likes.user_likes.int!
        self.likes = data.likes.count.int!
        
    }
    
    override static func primaryKey() -> String? {
        return "url"
    }
}
