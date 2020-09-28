//
//  Session.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 25.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

class Session {
    
    static let instance = Session()
    
    var token: String = ""
    var userId: Int = 0
    
    private init(){}
}
