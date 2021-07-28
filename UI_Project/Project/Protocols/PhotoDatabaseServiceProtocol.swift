//
//  PhotoDatabaseServiceProtocol.swift
//  UI_Project
//
//  Created by Shisetsu on 07.07.2021.
//

import Foundation
import RealmSwift

protocol PhotoDatabaseServiceProtocol {
    func add(photos: [PhotoModel])
    func read(userID: String) -> [PhotoModel]
    func delete(photo: PhotoModel)
    func readResults(userID: String) -> Results<PhotoModel>?
}
