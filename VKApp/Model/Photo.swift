//
//  Photo.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 17.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//
import UIKit
import RealmSwift

struct PhotosResult: Codable {
    let response: PhotosResponse
}

struct PhotosResponse: Codable {
    let count: Int
    let items: [Photo]
}

struct Photo: Codable {
    let id: Double
    let sizes: [PhotoSize]
    let text: String
    let likes: PhotoLike
}

struct PhotoSize: Codable {
    let height: Int
    let width: Int
    let url: String
    let type: String
}

struct PhotoLike: Codable {
    let user_likes: Int
    let count: Int
}

class RealmPhoto: Object {
    @objc dynamic var id = 0.0
    @objc dynamic var text = ""
    @objc dynamic var photo = ""
    @objc dynamic var user_likes = 0
    @objc dynamic var likesCount = 0
    
    convenience init(id: Double, text: String, photo: String, user_likes: Int, likesCount: Int) {
        self.init()
        
        self.id = id
        self.text = text
        self.photo = photo
        self.user_likes = user_likes
        self.likesCount = likesCount
    }
}
