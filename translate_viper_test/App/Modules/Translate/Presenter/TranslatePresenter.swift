//
//  TranslateInteractor.swift
//  translate_viper_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation
import NotificationCenter

protocol TranslatePresenterProtocol: class {
	
	var interactor: TranslateInteractorProtocol? { get set }
	var view: TranslateViewProtocol? { get set }
	var modal: Bool { get set }
	
	func setDirection()
	func translate(text: String)
	func handleTapNavBar(tag: Int)
	func handleLangSelection(primary: Langs?, secondary: Langs?)
	
	func setTranslation(dict: Dict)
}

class TranslatePresenter: TranslatePresenterProtocol {
	
	// MARK: Variables
	
	var router: TranslateRouter?
	weak var view: TranslateViewProtocol? {
		didSet {
			view?.presenter = self
			let notificationCenter        = NotificationCenter.default
			notificationCenter.addObserver(self, selector: #selector(onDidReceiveData(notfication:)), name: .setDirection, object: nil)
		}
	}
	var interactor: TranslateInteractorProtocol? {
		didSet { interactor?.presenter = self }
	}
	
	var currentDirection: Direction? {
		didSet {
			guard let currentDirection = currentDirection else { return }
			view?.updateNavBar(direction: currentDirection)
		}
	}
	
	var modal: Bool = false
	
	init(router: TranslateRouter) {
		self.router     = router
	}
	
	// MARK: Translation
	
	// set translation direction when launching app
	func setDirection() {
		guard !modal else { return }
		if let primary = UserDefaults.standard.string(forKey: "primary"),
			let secondary = UserDefaults.standard.string(forKey: "secondary") {
			
			let primaryLang = Langs.getLangByCode(code: primary)
			let secondaryLang = Langs.getLangByCode(code: secondary)
			
			currentDirection = Direction(primary: primaryLang, secondary: secondaryLang)
			saveCurrentDirection()
		}
		
	}
	
	// this func is used only for representation translation data chosen from List VC, all UI interactions are disabled
	func setTranslation(dict: Dict) {
		guard let primary = dict.primaryLang, let secondary = dict.secondaryLang, let translation = dict.secondaryWord else { return }
		
		let primaryLang = Langs.getLangByCode(code: primary)
		let secondaryLang = Langs.getLangByCode(code: secondary)
		print("set translation: primary: \(primaryLang.desc ?? ""), secondary: \(secondaryLang.desc ?? "")")
		
		currentDirection = nil
		currentDirection = Direction(primary: primaryLang, secondary: secondaryLang)
		view?.setTranslation(origin: dict.primaryWord, translation: translation)
		
		view?.blockUI()
		
	}
	
	@objc func onDidReceiveData(notfication: NSNotification) {
		print("translate presenter: didRecieveNotification ", self)
		setDirection()
	}
	
	private func saveCurrentDirection() {
		guard let currentDirection = currentDirection else { return }
		UserDefaults.standard.set(currentDirection.primary.code, forKey: "primary")
		UserDefaults.standard.set(currentDirection.secondary.code, forKey: "secondary")
		print("successfully save \(currentDirection.primary.code ?? "") for primary and \(currentDirection.secondary.code ?? "") for secondary")
	}
	
	// used for translation and then for updating UI
	func translate(text: String) {
		guard let currentDirection = currentDirection else { return }
		interactor?.translate(text: text, direction: currentDirection, completion: { [weak self] (text) in
			if let text = text, !text.isEmpty {
				self?.view?.setTranslation(origin: nil, translation: text)
			}
		})
	}
	
	func handleLangSelection(primary: Langs?, secondary: Langs?) {
		if let primary = primary {
			currentDirection?.primary = primary
			view?.setTranslation(origin: "", translation: "")
		} else if let secondary = secondary {
			currentDirection?.secondary = secondary
			view?.setTranslation(origin: nil, translation: "")
		}
		saveCurrentDirection()
		
		if let text = view?.getCurrentWord() {
			translate(text: text)
		}
	}
	
	// MARK: Routing
	
	// used for changing language
	func handleTapNavBar(tag: Int) {
		switch tag {
		case 0:
			router?.push(.changeLang(primary: true))
		case 1:
			guard let currentDirection = currentDirection else { return }
			
			let newDirection = Direction(primary: currentDirection.secondary, secondary: currentDirection.primary)
			self.currentDirection = newDirection
			saveCurrentDirection()
			
			view?.switchWords()
			
		case 2:
			router?.push(.changeLang(primary: false))
		default:
			break
		}
	}
	
}
