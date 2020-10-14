//
//  LocalDataBaseService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 07.10.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class LocalDataBaseService {
    let storeStack = CoreDataStack(modelName: "LocalDB")
    
    func saveUser(id: Double, first_name: String, last_name: String, photo_50: String) {
        let context = storeStack.persistentContainer.viewContext
        let user = LocalUser(context: context)
        user.id = id
        user.first_name = first_name
        user.last_name = last_name
        user.photo_50 = photo_50
        storeStack.saveContext()
    }
    
    func readUserList() -> [LocalUser] {
        let context = storeStack.persistentContainer.viewContext
        
        return (try? context.fetch(LocalUser.fetchRequest()) as? [LocalUser]) ?? []
    }
}
