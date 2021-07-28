//
//  VKSession.swift
//  UI_Project
//
//  Created by Shisetsu on 17.06.2021.
//

import Foundation

final class VKSession {

    static let currentSession = VKSession()

    var token = String()
    var userId = String()

    private init() {}

}
