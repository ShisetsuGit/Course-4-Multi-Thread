//
//  APIRequests.swift
//  UI_Project
//
//  Created by Shisetsu on 24.06.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import PromiseKit

final class APIRequest {
    
    let baseUrl = "https://api.vk.com/method"
    let token = VKSession.currentSession.token
    let cliendId = VKSession.currentSession.userId
    let version = "5.131"
    
//    MARK: - DB SERVICES
    let groupsDB = GroupsDatabaseService()
    let photosDB = PhotoDatabaseService()
    let newsGroupsDB = NewsGroupsDatabaseService()
    let newsDB = NewsDatabaseService()
    
    //    MARK: - GET USER FRIENDS
    func getFriends() {
        
        let operation = OperationQueue()
        
        let method = "/friends.get"
        let parameters: Parameters = [
            "user_id": cliendId,
            "order": "name",
            "fields": "sex,bdate,city,photo_100,photo_50,online,status",
            "access_token": token,
            "v": version]
        let url = baseUrl + method
        
        let request = AF.request(url, method: .get, parameters: parameters)
        print(request as Any)
        
        let getDataOperation = GetDataOperation(request: request)
        operation.addOperation(getDataOperation)
        
        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        operation.addOperation(parseData)
        
        let reloadTableController = LoadFrindsToRealm()
        reloadTableController.addDependency(parseData)
        OperationQueue.main.addOperation(reloadTableController)
    }
    
    //    MARK: - GET USER PHOTOS
    func getPhoto(userID: String) -> Promise<Data> {
        
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
        
        let promise = Promise<Data> { resolver in
            AF.request(url, method: .get, parameters: parameters).responseData{ response in
                print(response.request as Any)
                guard let data = response.data else { return }
                resolver.fulfill(data)
            }
        }
        return promise
    }
    
    func photoPromiseParser(_ data: Data) -> Promise<Array<JSON>> {
            let promise = Promise<Array<JSON>> { resolver in
                do {
                    guard let items = try JSON(data: data).response.items.array else { return }
                    resolver.fulfill(items)
                } catch {
                    print(error.localizedDescription)
                    resolver.reject(error)
                }
            }
            return promise
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
    
    //    MARK: - GET NEWS
    func getNews(startFrom: String = "", startTime: Double? = nil, completion: @escaping (String) -> Void) {
        
        let method = "/newsfeed.get"
        var parameters: Parameters = [
            "filters": "post",
            "count": 10,
            "start_from": startFrom,
            "access_token": token,
            "v": version]
        let url = baseUrl + method
        
        if let startTime = startTime {
            parameters["start_time"] = startTime
        }
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            print(response.request as Any)
            
            guard let data = response.data else { return }
            let nextFrom = JSON(data).response.next_from.string
            
            let itemsQueue = DispatchQueue(label: "ItemsParsing",
                                           qos: .userInitiated,
                                           attributes: .concurrent)
            let groupsQueue = DispatchQueue(label: "GroupsParsing",
                                           qos: .userInitiated,
                                           attributes: .concurrent)
            
            itemsQueue.async {
                print("1 Parsing items")
                guard let itemsNews = JSON(data).response.items.array else { return }
                let news: [NewsModel] = itemsNews.map { NewsModel(data: $0) }
                print("news")
                print(news)
                DispatchQueue.main.async {
                    print("1.1 Write items data to DB")
                    self.newsDB.add(news: news)
                }
            }
            
            groupsQueue.async {
                print("1 Parsing groups")
                guard let itemsGroups = JSON(data).response.groups.array else { return }
                let groups: [NewsGroupsModel] = itemsGroups.map { NewsGroupsModel(data: $0) }
                DispatchQueue.main.async {
                    print("1.1 Write groups data to DB")
                    self.newsGroupsDB.add(newsGroups: groups)
                }
            }
            if let nextFrom = nextFrom {
                completion(nextFrom)
            }
        }
    }
}
