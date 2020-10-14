//
//  User.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 08.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

struct FriendsResult: Codable {
    let response: FriendsResponse
}

struct FriendsResponse: Codable {
    let count: Int
    let items: [User]
}

struct User: Codable {
    let id: Double
    let first_name: String
    let last_name: String
    let photo_50: String
    var name: String {
        return last_name == "" ? first_name : last_name + " " + first_name
    }
    
    func getNameFirstLetter() -> String {
        return String(name.first ?? "z")
    }
}
