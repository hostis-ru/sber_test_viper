//
//  SettingsPresenter.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

protocol SettingsPresenterProtocol: class {
	
	var view: SettingsViewProtocol? { get set }
	var interactor: SettingsInteractorProtocol? { get set }
	
	var data: [Langs]? { get set }
	
	func getLanguages()
}

class SettingsPresenter: SettingsPresenterProtocol {
	
	var router: SettingsRouter?
	weak var view: SettingsViewProtocol? {
		didSet {
			view?.presenter = self
			if let primary = UserDefaults.standard.string(forKey: "primary") {
				selectedLang = Langs.getLangByCode(code: primary)
			}
			view?.chooseLangHandler = { [weak self] (lang) in
				self?.selectedLang = lang
			}
		}
	}
	var interactor: SettingsInteractorProtocol? {
		didSet {
			interactor?.presenter = self
			interactor?.getLanguages(completion: { [weak self] in
				self?.getLanguages()
			})
		}
	}
	
	var chooseLangHandler: ((Langs) -> ())? {
		didSet {
			view?.chooseLangHandler = self.chooseLangHandler
		}
	}
	
	var data: [Langs]? {
		didSet {
			view?.setupTableView()
		}
	}
	
	var selectedLang: Langs? {
		didSet {
			guard let selectedLang = selectedLang else { return }
			UserDefaults.standard.set(selectedLang.code, forKey: "primary")
			print("successfully set \(selectedLang.code ?? "") for primary")
		}
	}
	
	
	init(router: SettingsRouter) {
		self.router     = router
	}
	
	func getLanguages() {
		interactor?.fetchData(completion: { [weak self] (arr) in
			if let arr = arr, !arr.isEmpty {
				self?.data = arr
			}
		})
	}
}
