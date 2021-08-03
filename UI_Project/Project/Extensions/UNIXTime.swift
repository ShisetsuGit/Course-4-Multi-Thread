//
//  UNIXTime.swift
//  UI_Project
//
//  Created by Shisetsu on 02.08.2021.
//

import Foundation

func UNIXTime(unixDate: Int, completion: @escaping(String)->()) {
    
    let getDate = Date(timeIntervalSince1970: TimeInterval(unixDate))
    let stringDate = "\(getDate)"
    let nowDate = Int(Date().timeIntervalSince1970)
    
    let dateFormatterGet = DateFormatter()
    let dateFormatterSet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    dateFormatterSet.locale = Locale(identifier: "ru_RU")
    
    let comparsion = nowDate - unixDate
    
    switch comparsion {
    case 0..<3600:
        dateFormatterSet.dateFormat = "в HH:mm"
    case 3600..<7200:
        dateFormatterSet.dateFormat = "Час назад"
    case 7200..<10800:
        dateFormatterSet.dateFormat = "Два часа назад"
    case 10800..<14400:
        dateFormatterSet.dateFormat = "Три часа назад"
    default:
        dateFormatterSet.dateFormat = "d MMMM в HH:mm"
    }
    
    if let date = dateFormatterGet.date(from: stringDate) {
        print(dateFormatterSet.string(from: date))
        completion(dateFormatterSet.string(from: date))
    } else {
       print("There was an error decoding the string")
    }
}
