//
//  SetingsInteractor.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

protocol SettingsInteractorProtocol: class {
	
	var presenter: SettingsPresenterProtocol? { get set }
	
	func getLanguages(completion: @escaping () -> ())
	func fetchData(completion: @escaping ([Langs]?) -> ())
}

class SettingsInteractor: SettingsInteractorProtocol {
	
	var presenter: SettingsPresenterProtocol?
	
	func getLanguages(completion: @escaping () -> ()) {
		APIManager.getLanguages { (json) in
			
			// fill core data with all possible languages at app start
			self.fetchData(completion: { (arr) in
				if let arr = arr, !arr.isEmpty {
				} else {
					if let items = json["langs"] as? [String: String] {
						
						for (key, value) in items {
							let lang = Langs(context: CoreDataManager.instance.context)
							lang.code = key
							lang.desc = value
							
							CoreDataManager.instance.saveContext()
						}
					}
				}
			})
			
			// standard languages
			if UserDefaults.standard.string(forKey: "primary") == nil,
				UserDefaults.standard.string(forKey: "secondary") == nil {
				
				UserDefaults.standard.set("ru", forKey: "primary")
				UserDefaults.standard.set("en", forKey: "secondary")
			}
			
			completion()
		}
	}
	
	func fetchData(completion: @escaping ([Langs]?) -> ()) {
		let dict = Langs.getAllLangs()
		completion(dict)
	}
}
