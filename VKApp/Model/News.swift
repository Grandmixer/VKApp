//
//  News.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 19.12.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation
import RealmSwift

struct NewsResult: Codable {
    let response: NewsResponse
}

struct NewsResponse: Codable {
    let items: [News]
    let profiles: [RealmUser]
    let groups: [RealmGroup]
}

struct News: Codable {
    let source_id: Double
    let date: Double
    let text: String
    let likes: PhotoLike
}

