//
//  ListPresenter.swift
//  translate_viper_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

protocol ListPresenterProtocol: class {
	
	var view: ListViewProtocol? { get set }
	var interactor: ListInteractorProtocol? { get set }
	
	var currentData: [Dict] { get set }
	
	func fetchData()
	func deleteItems()
	
	func handleDidSelect(item: Dict)
	func handleSearchDidChange(text: String)
}

class ListPresenter: ListPresenterProtocol {
	
	// MARK: Variables
	
	var router: ListRouter?
	weak var view: ListViewProtocol? {
		didSet { view?.presenter = self }
	}
	var interactor: ListInteractorProtocol? {
		didSet { interactor?.presenter = self }
	}
	
	var data = [Dict]() {
		didSet {
			setCurrentData()
		}
	}
	
	var currentData = [Dict]() {
		didSet {
			view?.reloadData()
		}
	}
	
	init(router: ListRouter) {
		self.router     = router
	}
	
	// MARK:
	
	func setCurrentData() {
		currentData = data
	}
	
	// handling search filtering
	func handleSearchDidChange(text: String) {
		guard !text.isEmpty else {
			currentData = data
			view?.reloadData()
			return
		}
		
			currentData = data.filter({ (item) -> Bool in
				guard let searchText = item.primaryWord else { return false}
				return searchText.contains(text)
				// filtering by primary word
			})
			if currentData.isEmpty {
				print("search by primary word failed")
				
				currentData = data.filter({ (item) -> Bool in
					guard let searchText = item.secondaryWord else { return false}
					return searchText.contains(text)
					// filtering by secondary word
				})
			}
			
			view?.reloadData()
	}
	
	func fetchData() {
		interactor?.fetchData(completion: { (data) in
			if let data = data, !data.isEmpty {
				self.data = data
				
			}
		})
	}
	
	func deleteItems() {
		interactor?.deleteItems { [weak self] in
			self?.view?.reloadData()
		}
	}
	
	
	// MARK: Routing
	
	func handleDidSelect(item: Dict) {
		router?.push(.translation(dict: item))
	}
	
}
