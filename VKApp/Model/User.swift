//
//  User.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 08.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

struct User {
    let name: String
    let avatar: UIImage?
    var gallery: [Photo]
    
    func getNameFirstLetter() -> String {
        return String(name.first ?? "z")
    }
}
