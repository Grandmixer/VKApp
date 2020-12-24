//
//  NewsService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 19.12.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation

class NewsService: JsonService {
    
    func loadNews(completion: @escaping (NewsResult) -> Void) {
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
        urlConstructor.path = "/method/newsfeed.get"
        //Параметры для запроса
        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        doTask(session, urlConstructor.url!, parcingType: NewsResult.self, completion: completion)
    }
}
