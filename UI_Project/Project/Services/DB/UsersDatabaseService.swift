//
//  UsersDatabaseService.swift
//  UI_Project
//
//  Created by Shisetsu on 05.07.2021.
//

import Foundation
import RealmSwift

class UsersDatabaseService: UsersDatabaseServiceProtocol {
    
    let config = Realm.Configuration(schemaVersion: 1)
    lazy var realm = try! Realm(configuration: config)
    
    func add(user: [UserModel]) {
        
        do {
            self.realm.beginWrite()
            self.realm.add(user, update: .modified)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read() -> [UserModel] {
        let users = self.realm.objects(UserModel.self).sorted(byKeyPath: "firstName")
        return Array(users)
    }
    
    func readResults() -> Results<UserModel>? {
        let usersResults = self.realm.objects(UserModel.self).sorted(byKeyPath: "firstName")
        return usersResults
    }
    
    func delete(user: UserModel) {
        
        do {
            self.realm.beginWrite()
            self.realm.delete(user)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
