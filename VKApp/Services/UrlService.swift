//
//  Service.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 03.10.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation

class UrlService {
    
    func doTask<T: Decodable>(_ session: URLSession, _ url: URL, parcingType: T.Type, completion: @escaping (T) -> Void) {
        //Задача для запуска
        let task = session.dataTask(with: url) { (data, response, error) in
            //Преобразуем полученные данные в json
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) else {
                return
            }
            print(json)
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(parcingType, from: data) {
                completion(result)
            }
        }
        //Запускаем задачу
        task.resume()
    }
}
