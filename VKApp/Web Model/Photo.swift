//
//  Photo.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 17.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//
import UIKit

struct PhotosResult: Codable {
    let response: PhotosResponse
}

struct PhotosResponse: Codable {
    let count: Int
    let items: [Photo]
}

struct Photo: Codable {
    let id: Int
    let sizes: [PhotoSize]
    let text: String
    let likes: [PhotoLike]
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
