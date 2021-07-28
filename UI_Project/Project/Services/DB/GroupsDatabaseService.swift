//
//  GroupsDatabaseService.swift
//  UI_Project
//
//  Created by Shisetsu on 06.07.2021.
//

import Foundation
import RealmSwift

class GroupsDatabaseService: GroupsDatabaseServiceProtocol {
    
    let config = Realm.Configuration(schemaVersion: 1)
    lazy var realm = try! Realm(configuration: config)
    
    func add(groups: [GroupsModel]) {
        
        do {
            self.realm.beginWrite()
            self.realm.add(groups, update: .modified)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read() -> [GroupsModel] {
        let groups = self.realm.objects(GroupsModel.self)
        return Array(groups)
    }
    
    func readResults() -> Results<GroupsModel>? {
        let groupsResults = self.realm.objects(GroupsModel.self).sorted(byKeyPath: "name")
        return groupsResults
    }
    
    func delete(groups: GroupsModel) {
        
        do {
            self.realm.beginWrite()
            self.realm.delete(groups)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
