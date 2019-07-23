//
//  Dict+CoreDataClass.swift
//  sber_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dict)
public class Dict: NSManagedObject {

	public static func getAllTranslations() -> [Dict] {
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dict")
		//		request.predicate = NSPredicate(format: "ANY employee.firstName = %@", name)
		do {
			if let result = try CoreDataManager.instance.context.fetch(request) as? [Dict] {
				result.forEach({
					print("res: ", $0.primaryWord ?? "")
				})
				return result
			}
		} catch { }
		return [Dict]()
	}
	
}
