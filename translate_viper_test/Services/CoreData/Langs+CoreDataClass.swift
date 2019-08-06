//
//  Langs+CoreDataClass.swift
//  translate_viper_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Langs)
public class Langs: NSManagedObject {

	public static func getAllLangs() -> [Langs] {
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Langs")
		let sortDescriptor = NSSortDescriptor(key: "desc", ascending: true)
		request.sortDescriptors = [sortDescriptor]
		do {
			if let result = try CoreDataManager.instance.context.fetch(request) as? [Langs] {
//				result.forEach({
//					print("res: \($0.desc ?? "")")
//				})
				return result
			}
		} catch { }
		return [Langs]()
	}
	
	public static func getLangByCode(code: String) -> Langs {
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Langs")
		request.predicate = NSPredicate(format: "ANY code = %@", code)
		do {
			if let result = try CoreDataManager.instance.context.fetch(request) as? [Langs] {
				if let res = result.first {
					print("found lang \(res.desc ?? "") for code \(code)")
					return res
				}
			}
		} catch { }
		return Langs()
	}
	
}
