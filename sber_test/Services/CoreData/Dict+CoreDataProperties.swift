//
//  Dict+CoreDataProperties.swift
//  sber_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//
//

import Foundation
import CoreData


extension Dict {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dict> {
        return NSFetchRequest<Dict>(entityName: "Dict")
    }

    @NSManaged public var primaryLang: String?
    @NSManaged public var primaryWord: String?
    @NSManaged public var secondaryLang: String?
    @NSManaged public var secondaryWord: String?

}
