//
//  LoadFrindsToRealm.swift
//  UI_Project
//
//  Created by Shisetsu on 04.08.2021.
//

import Foundation
class LoadFrindsToRealm: Operation {
    var userDB = UsersDatabaseService()
    
    override func main() {
        guard let parseData = dependencies.first as? ParseData else { return }
        self.userDB.add(user: parseData.friendsData)
        print("Load to DB finished")
  }
}
