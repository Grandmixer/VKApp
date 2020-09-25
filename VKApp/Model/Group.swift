//
//  Group.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 21.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

struct Group {
    let name: String
    let avatar: UIImage?
    var index: Int
    
    func getNameFirstLetter() -> String {
        return String(name.first ?? "z")
    }
}
