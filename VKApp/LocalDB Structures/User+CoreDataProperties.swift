    //
//  User+CoreDataProperties.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 07.10.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalUser> {
        return NSFetchRequest<LocalUser>(entityName: "LocalUser")
    }

    @NSManaged public var id: Double
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var photo_50: String?

}

extension LocalUser : Identifiable {

}
