//
//  APIRequests.swift
//  UI_Project
//
//  Created by Shisetsu on 24.06.2021.
//

import Foundation
import Alamofire
import DynamicJSON

final class APIRequest {
    
    let baseUrl = "https://api.vk.com/method"
    let token = VKSession.currentSession.token
    let cliendId = VKSession.currentSession.userId
    let version = "5.138"
    
//    MARK: - DB SERVICES
    let userDB = UsersDatabaseService()
    let groupsDB = GroupsDatabaseService()
    let photosDB = PhotoDatabaseService()
    let newsGroupsDB = NewsGroupsDatabaseService()
    let newsDB = NewsDatabaseService()
    
    //    MARK: - GET USER FRIENDS
    func getFriends() {
        
        let method = "/friends.get"
        let parameters: Parameters = [
            "user_id": cliendId,
            "order": "name",
            "fields": "sex,bdate,city,photo_100,photo_50,online,status",
            "access_token": token,
            "v": version]
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            print(response.request as Any)
            
            guard let data = response.data else { return }
            guard let items = JSON(data).response.items.array else { return }
            let friends: [UserModel] = items.map { UserModel(data: $0) }
            
            DispatchQueue.main.async {
                self.userDB.add(user: friends)
            }
        }
    }
    
    //    MARK: - GET USER PHOTOS
    func getPhoto(userID: String) {
        
        let method = "/photos.getAll"
        let parameters: Parameters = [
            "owner_id": userID,
            "photo_sizes": 1,
            "count": 5,
            "extended": 1,
            "no_service_albums": 1,
            "access_token": token,
            "v": version]
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            print(response.request as Any)
            
            guard let data = response.data else { return }
            guard let items = JSON(data).response.items.array else { return }
            
            print(items)
            
            let url: [PhotoModel] = items.map { PhotoModel(data: $0) }
            
            DispatchQueue.main.async {
                self.photosDB.add(photos: url)
            }
        }
    }
    
    //    MARK: - GET USER GROUPS
    func getGroups() {
        
        let method = "/groups.get"
        let parameters: Parameters = [
            "user_id": cliendId,
            "order": "name",
            "extended": 1,
            "access_token": token,
            "v": version]
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            print(response.request as Any)
            
            guard let data = response.data else { return }
            guard let items = JSON(data).response.items.array else { return }
            let groups: [GroupsModel] = items.map { GroupsModel(data: $0) }
            DispatchQueue.main.async {
                self.groupsDB.add(groups: groups)
            }
        }
    }
    
    //    MARK: - GET SEARSCHED GROUPS
    func searchGroups(searchText: String, completion: @escaping([GroupsModel])->()) {
        
        let method = "/groups.search"
        let parameters: Parameters = [
            "user_id": cliendId,
            "q": searchText,
            "access_token": token,
            "v": version]
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            guard let data = response.data else { return }
            guard let items = JSON(data).response.items.array else { return }
            let searchedGroups: [GroupsModel] = items.map { GroupsModel(data: $0) }
            DispatchQueue.main.async {
                completion(searchedGroups)
            }
        }
    }
    
    //    MARK: - GET NEWS (TYPE: Post)
    func getNews() {
        
        let method = "/newsfeed.get"
        let parameters: Parameters = [
            "filters": "post",
            "count": 50,
            "access_token": token,
            "v": version]
        let url = baseUrl + method
        
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            print(response.request as Any)
            
            guard let data = response.data else { return }
            guard let itemsNews = JSON(data).response.items.array else { return }
            let news: [NewsModel] = itemsNews.map { NewsModel(data: $0) }
            guard let itemsGroups = JSON(data).response.groups.array else { return }
            let groups: [NewsGroupsModel] = itemsGroups.map { NewsGroupsModel(data: $0) }
            DispatchQueue.main.async {
                self.newsGroupsDB.add(newsGroups: groups)
                self.newsDB.add(news: news)
            }
            
        }
    }
}
