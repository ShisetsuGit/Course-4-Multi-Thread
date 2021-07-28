//
//  UserModel.swift
//  UI_Project
//
//  Created by Shisetsu on 05.07.2021.
//

import Foundation
import DynamicJSON
import RealmSwift

class UserModel: Object {
    
    @objc dynamic var id: String?
    @objc dynamic var sex: Int = 0
    @objc dynamic var firstName: String?
    @objc dynamic var bdate: String? = nil
    @objc dynamic var city: String? = nil
    @objc dynamic var lastName: String?
    @objc dynamic var photo100: String?
    @objc dynamic var photo50: String?
    @objc dynamic var online: Int = 0
    @objc dynamic var status: String? = nil
   
    
    convenience required init(data: JSON) {
        self.init()
        
        self.id = data.id.string
        self.sex = data.sex.int!
        self.firstName = data.first_name.string
        self.bdate = data.bdate.string
        self.city = data.city.title.string
        self.lastName = data.last_name.string
        self.photo100 = data.photo_100.string
        self.photo50 = data.photo_50.string
        self.online = data.online.int!
        self.status = data.status.string
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
