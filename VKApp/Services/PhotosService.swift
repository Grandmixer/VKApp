//
//  FriendsService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 28.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation

class PhotosService: UrlService {
    
    func loadPhotosList(completion: @escaping (PhotosResult) -> Void) {
        //Конфигурация по умолчанию
        let configuration = URLSessionConfiguration.default
        //Собственная сессия
        let session = URLSession(configuration: configuration)
        //Токен
        let token = Session.instance.token
        
        //Создаем конструктор для URL
        var urlConstructor = URLComponents()
        //Устанавливаем схему
        urlConstructor.scheme = "http"
        //Устанавливаем хост
        urlConstructor.host = "api.vk.com"
        //Путь
        urlConstructor.path = "/method/photos.get"
        //Параметры для запроса
        urlConstructor.queryItems = [
            URLQueryItem(name: "album_id", value: "wall"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        doTask(session, urlConstructor.url!, parcingType: PhotosResult.self, completion: completion)
    }
}
