//
//  File.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

protocol ListInteractorProtocol: class {
	
	var presenter: ListPresenterProtocol? { get set }
	
	func fetchData(completion: @escaping ([Dict]?)->())
	func deleteItems(completion: @escaping (()->()))
}

class ListInteractor: ListInteractorProtocol {
	
	weak var presenter: ListPresenterProtocol?
	
	func fetchData(completion: @escaping ([Dict]?) -> ()) {
		let dict = Dict.getAllTranslations()
		completion(dict)
	}
	
	func deleteItems(completion: @escaping (()->())) {
		fetchData { (arr) in
			arr?.forEach({ (item) in
				CoreDataManager.instance.context.delete(item)
				CoreDataManager.instance.saveContext()
			})
			
			completion()
		}
	}
}
