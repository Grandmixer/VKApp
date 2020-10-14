//
//  Group.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 21.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

struct GroupsResult: Codable {
    let response: GroupsResponse
}

struct GroupsResponse: Codable {
    let count: Int
    let items: [Group]
}

struct Group: Codable {
    let id: Double
    let name: String
    let photo_50: String
    
    func getNameFirstLetter() -> String {
        return String(name.first ?? "z")
    }
}
