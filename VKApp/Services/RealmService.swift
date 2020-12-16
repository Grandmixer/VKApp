//
//  RealmService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 13.10.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    func saveUserData(_ users: [RealmUser]) {
        do {
            let realm = try Realm()
            
            let oldUsers = realm.objects(RealmUser.self)
            
            realm.beginWrite()
            
            realm.delete(oldUsers)
            realm.add(users)
            
            try realm.commitWrite()
            print(realm.configuration.fileURL)
        } catch {
            print(error)
        }
    }
    
    func saveGroupData(_ groups: [RealmGroup]) {
        do {
            let realm = try Realm()
            
            let oldGroups = realm.objects(RealmGroup.self)
            
            realm.beginWrite()
            
            realm.delete(oldGroups)
            realm.add(groups)
            
            try realm.commitWrite()
            print(realm.configuration.fileURL)
        } catch {
            print(error)
        }
    }
    
    func loadGroupData() -> [Group] {
        do {
            let realm = try Realm()
            
            let realmGroups = realm.objects(RealmGroup.self)
            var groups: [Group] = []
            
            //Преобразовываем в структуру данных, с которой работает интерфейс
            for rGroup in realmGroups {
                let group = Group(id: rGroup.id, name: rGroup.name, photo: rGroup.photo_50)
                groups.append(group)
            }
            
            return groups
        } catch {
            print(error)
        }
        return []
    }

    func savePhotoData(_ photos: [RealmPhoto]) {
        do {
            let realm = try Realm()
            
            let oldPhotos = realm.objects(RealmPhoto.self)
            
            realm.beginWrite()
            
            realm.delete(oldPhotos)
            realm.add(photos)
            
            try realm.commitWrite()
            print(realm.configuration.fileURL)
        } catch {
            print(error)
        }
    }
}
