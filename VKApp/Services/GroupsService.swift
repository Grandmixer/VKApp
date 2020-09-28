//
//  FriendsService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 28.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation

class GroupsService {
    
    func loadGroupsList() {
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
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: "5.124")
        ]
        
        //Задача для запуска
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            //Преобразуем полученные данные в json
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            //Выводим в консоль
            print(json)
        }
        //Запускаем задачу
        task.resume()
    }
}
