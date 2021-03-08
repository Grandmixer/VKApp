//
//  FriendsService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 28.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation
import PromiseKit

class GroupsService: JsonService {
    
    func loadGroupsList(completion: @escaping (GroupsResult) -> Void) {
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
        urlConstructor.path = "/method/groups.get"
        //Параметры для запроса
        urlConstructor.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        doTask(session, urlConstructor.url!, parcingType: GroupsResult.self, completion: completion)
    }
    
    func loadGroupsListFuture() -> Promise<GroupsResult> {
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
        urlConstructor.path = "/method/groups.get"
        //Параметры для запроса
        urlConstructor.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        return session.dataTask(.promise, with: urlConstructor.url!)
            .then(on: DispatchQueue.global()) { response -> Promise<GroupsResult> in
                let result = try? JSONDecoder().decode(GroupsResult.self, from: response.data)
                return Promise.value(result ?? GroupsResult(response: GroupsResponse(count: 0, items: [])))
            }
    }
    
    func searchGroups(substring: String, completion: @escaping (GroupsResult) -> Void) {
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
        urlConstructor.path = "/method/groups.search"
        //Параметры для запроса
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: substring),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "count", value: "1000"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        doTask(session, urlConstructor.url!, parcingType: GroupsResult.self, completion: completion)
    }
}
