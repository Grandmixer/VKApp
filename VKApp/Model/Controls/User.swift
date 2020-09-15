//
//  User.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 08.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation

struct User {
    let name: String
    //Место для расширения класса
    
    func getNameFirstLetter() -> String {
        return String(name.first ?? "z")
    }
}
