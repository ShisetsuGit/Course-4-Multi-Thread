//
//  PhotoDatabaseService.swift
//  UI_Project
//
//  Created by Shisetsu on 07.07.2021.
//

import Foundation
import RealmSwift

class PhotoDatabaseService: PhotoDatabaseServiceProtocol {
    
    
    let config = Realm.Configuration(schemaVersion: 1)
    lazy var realm = try! Realm(configuration: config)
    
    func add(photos: [PhotoModel]) {
        
        do {
            self.realm.beginWrite()
            self.realm.add(photos, update: .modified)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read(userID: String) -> [PhotoModel] {
        let photos = self.realm.objects(PhotoModel.self).filter("id = '\(userID)'")
        return Array(photos)
    }
    
    func readResults(userID: String) -> Results<PhotoModel>? {
        let photosResults = self.realm.objects(PhotoModel.self).filter("id = '\(userID)'")
        return photosResults
    }
    
    func delete(photo: PhotoModel) {
        
        do {
            self.realm.beginWrite()
            self.realm.delete(photo)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
