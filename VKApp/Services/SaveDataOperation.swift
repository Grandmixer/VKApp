//
//  SaveDataOperation.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 25.02.2021.
//  Copyright © 2021 OlwaStd. All rights reserved.
//

import Foundation
import RealmSwift

class SaveDataOperation: Operation {
    
    override func main() {
        guard let parseDataOperation = dependencies.first as? ParseDataOperation else { return }
        
        guard let users: [RealmUser] = parseDataOperation.outputData?.response.items else { return }
        
        do {
            let realm = try Realm()
            
            let oldUsers = realm.objects(RealmUser.self)
            
            realm.beginWrite()
            
            realm.delete(oldUsers)
            realm.add(users)
            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
