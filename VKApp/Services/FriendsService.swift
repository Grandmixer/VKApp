//
//  FriendsService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 28.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation

class FriendsService: JsonService {
    
    func loadFriendsList(completion: @escaping (FriendsResult) -> Void) {
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
        urlConstructor.path = "/method/friends.get"
        //Параметры для запроса
        urlConstructor.queryItems = [
            URLQueryItem(name: "fields", value: "nickname, photo_50"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        doTask(session, urlConstructor.url!, parcingType: FriendsResult.self, completion: completion)
    }
    
    func loadFriendListOp() {
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
        urlConstructor.path = "/method/friends.get"
        //Параметры для запроса
        urlConstructor.queryItems = [
            URLQueryItem(name: "fields", value: "nickname, photo_50"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        let queue = OperationQueue()
        
        let getData = GetDataOperation(session: session, url: urlConstructor.url!)
        queue.addOperation(getData)
        
        let parseData = ParseDataOperation()
        parseData.addDependency(getData)
        queue.addOperation(parseData)
        
        let saveData = SaveDataOperation()
        saveData.addDependency(parseData)
        queue.addOperation(saveData)
    }
}
