//
//  GroupsModel.swift
//  UI_Project
//
//  Created by Shisetsu on 06.07.2021.
//

import Foundation
import DynamicJSON
import RealmSwift

class GroupsModel: Object {
    
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var photo50: String?
    
    convenience required init(data: JSON) {
        self.init()
        
        self.id = data.id.string
        self.name = data.name.string
        self.photo50 = data.photo_50.string
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
