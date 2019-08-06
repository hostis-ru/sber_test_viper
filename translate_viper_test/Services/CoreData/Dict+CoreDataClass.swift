//
//  Dict+CoreDataClass.swift
//  translate_viper_test
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
	
	public static func getTranslation(origin: String, primaryLang: String, secondaryLang: String) -> Dict? {
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dict")
		let originPredicate = NSPredicate(format: "ANY primaryWord = %@", origin)
		let primaryPredicate = NSPredicate(format: "ANY primaryLang = %@", primaryLang)
		let secondaryPredicate = NSPredicate(format: "ANY secondaryLang = %@", secondaryLang)
		
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [originPredicate, primaryPredicate, secondaryPredicate])
		
		request.predicate = predicate
		do {
			if let result = try CoreDataManager.instance.context.fetch(request) as? [Dict] {
				if let res = result.first {
					print("found Dict: origin \(res.primaryWord ?? ""), translation \(res.secondaryWord ?? "")")
					return res
				}
			}
		} catch { }
		return nil
	}
	
}
