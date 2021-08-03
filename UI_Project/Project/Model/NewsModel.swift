//
//  NewsModel.swift
//  UI_Project
//
//  Created by Shisetsu on 15.07.2021.
//

import Foundation
import DynamicJSON
import RealmSwift

class NewsModel: Object {

    @objc dynamic var sourceId = 0
    @objc dynamic var postID = 0
    @objc dynamic var date = 0
    @objc dynamic var text: String?
    @objc dynamic var userLikes = 0
    @objc dynamic var likes = 0
    @objc dynamic var reposts = 0
    @objc dynamic var photo: String?
    @objc dynamic var comments = 0
    @objc dynamic var views = 0
    
    convenience required init(data: JSON) {
        self.init()
        
        self.postID = data.post_id.int!
        self.date = data.date.int!
        self.sourceId = data.source_id.int!
        if sourceId < 0 {
            self.sourceId.negate()
        }
        self.text = data.text.string
        self.userLikes = data.likes.user_likes.int!
        self.likes = data.likes.count.int!
        self.views = data.views.count.int!
        self.reposts = data.reposts.count.int!
        self.comments = data.comments.count.int!
        self.photo = data["attachments"][0].photo["sizes"][4].url.string
        if self.photo == nil {
            self.photo = "https://thumbs.dreamstime.com/b/no-image-available-icon-photo-camera-flat-vector-illustration-132483141.jpg"
        }
    }
    
    override static func primaryKey() -> String? {
        return "postID"
    }
}
