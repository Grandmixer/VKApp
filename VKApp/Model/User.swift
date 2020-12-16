//
//  User.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 08.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit
import RealmSwift

struct FriendsResult: Codable {
    let response: FriendsResponse
}

struct FriendsResponse: Codable {
    let count: Int
    let items: [RealmUser]
}

class RealmUser: Object, Codable {
    @objc dynamic var id: Double = 0.0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_50: String = ""
    dynamic var name: String {
        return last_name == "" ? first_name : last_name + " " + first_name
    }
    
    func getNameFirstLetter() -> String {
        return String(name.first ?? "Z")
    }
}
