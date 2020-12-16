//
//  Group.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 21.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit
import RealmSwift

struct GroupsResult: Codable {
    let response: GroupsResponse
}

struct GroupsResponse: Codable {
    let count: Int
    let items: [RealmGroup]
}

class RealmGroup: Object, Codable {
    @objc dynamic var id: Double = 0.0
    @objc dynamic var name: String = ""
    @objc dynamic var photo_50: String = ""
}

class Group {
    let id: Double
    let name: String
    let photo_50: String
    
    init(id: Double, name: String, photo: String) {
        self.id = id
        self.name = name
        self.photo_50 = photo
    }
    
    func getNameFirstLetter() -> String {
        return String(name.first ?? "z")
    }
}
