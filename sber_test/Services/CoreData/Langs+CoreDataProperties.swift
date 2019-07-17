//
//  Langs+CoreDataProperties.swift
//  sber_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//
//

import Foundation
import CoreData


extension Langs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Langs> {
        return NSFetchRequest<Langs>(entityName: "Langs")
    }

    @NSManaged public var code: String?
    @NSManaged public var desc: String?

}
