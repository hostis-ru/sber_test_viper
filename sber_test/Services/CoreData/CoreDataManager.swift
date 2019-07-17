//
//  CoreDataManager.swift
//  sber_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
	
	static let instance = CoreDataManager()
	
	private init() {}
	
	// MARK: - Core Data stack
	
	lazy var context: NSManagedObjectContext = {
		let context:NSManagedObjectContext           = self.persistentContainer.viewContext
		context.automaticallyMergesChangesFromParent = true
		return context
	}()
	
	lazy var backgroundContext: NSManagedObjectContext = {
		return self.persistentContainer.newBackgroundContext()
	}()
	
	lazy var persistentContainer: NSPersistentContainer = {
		
		// use sharedPersistentContainer to acces database in shared group
		let container = NSPersistentContainer(name: "sber_test")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
			print("storeDescription = \(storeDescription)")
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: Core Data Stack Tasks
	
	func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
		self.context.perform {
			block(self.context)
		}
	}
	func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
		self.persistentContainer.performBackgroundTask(block)
	}
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
				print("saved succesfully")
			} catch {
				
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	
	// Entity for Name
	func entityForName(entityName: String) -> NSEntityDescription {
		return NSEntityDescription.entity(forEntityName: entityName, in: self.persistentContainer.viewContext)!
	}
	
	// Fetch
	
	
	
//	func fetch<Entity>(with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: @escaping (Result<[Entity]>) -> Void) where Entity : ManagedObjectConvertible {
//		
//		performForegroundTask { context in
//			do {
//				let fetchRequest             = Entity.ManagedObject.fetchRequest()
//				fetchRequest.predicate       = predicate
//				fetchRequest.sortDescriptors = sortDescriptors
//				
//				if let fetchLimit = fetchLimit {
//					fetchRequest.fetchLimit      = fetchLimit
//				}
//				
//				let results = try context.fetch(fetchRequest) as? [Entity.ManagedObject]
//				let items   = results?.compactMap { $0.toEntity() as? Entity } ?? []
//				completion(.success(items))
//			} catch {
//				NSLog("Core Data fetch error: \(error)")
//				completion(.failure(error))
//			}
//		}
//	}
//	
//	func update<Entity>(entities: [Entity], completion: @escaping (Error?) -> Void) where Entity : ManagedObjectConvertible {
//		
//		performBackgroundTask { context in
//			_ = entities.compactMap { $0.toManagedObject(context: context) }
//			
//			do {
//				try context.save()
//				completion(nil)
//			} catch {
//				NSLog("Core Data save error: \(error)")
//				completion(error)
//			}
//		}
//	}
//	
//	func delete<Entity>(entities: [Entity], completion: @escaping (Error?) -> Void) where Entity : ManagedObjectConvertible {
//		
//		performBackgroundTask { context in
//			let objects = entities.compactMap { $0.toManagedObject(context: context) }
//			
//			for object in objects {
//				context.delete(object)
//			}
//			
//			do {
//				try context.save()
//				completion(nil)
//			} catch {
//				NSLog("Core Data delete error: \(error)")
//				completion(error)
//			}
//		}
//	}
	
	
	
	
	func resetData() {
		let entities = persistentContainer.managedObjectModel.entities
		entities.compactMap ({ $0.name }).forEach(clearEntity)
		
		createDummyData()
	}
	
	private func clearEntity(_ name: String) {
		let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
		let batchDelete   = NSBatchDeleteRequest(fetchRequest: deleteRequest)
		
		do {
			try context.execute(batchDelete)
		} catch {
			NSLog("Batch delete error for \(name): \(error)")
		}
	}
	
	private func createDummyData() {
		
	}
	
	
	
}
