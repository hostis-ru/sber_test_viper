//
//  TranslateInteractor.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

protocol TranslatePresenterProtocol: class {
	
	var interactor: TranslateInteractorProtocol? { get set }
	var view: TranslateViewProtocol? { get set }
	
	func setDirection()
	func translate(text: String)
	func handleTapNavBar(tag: Int)
}

class TranslatePresenter: TranslatePresenterProtocol {
	
	var router: TranslateRouter?
	weak var view: TranslateViewProtocol? {
		didSet {
			view?.presenter = self
			setDirection()
		}
	}
	var interactor: TranslateInteractorProtocol? {
		didSet { interactor?.presenter = self }
	}
	
	var currentDirection: Direction? {
		didSet {
			saveCurrentDirection()
			view?.updateNavBar(direction: currentDirection!)
		}
	}
	
	init(router: TranslateRouter) {
		self.router     = router
	}
	
	func setDirection() {
		if let primary = UserDefaults.standard.string(forKey: "primary"),
			let secondary = UserDefaults.standard.string(forKey: "secondary") {
			
			let primaryLang = Langs.getLangByCode(code: primary)
			let secondaryLang = Langs.getLangByCode(code: secondary)
			
			currentDirection = Direction(primary: primaryLang, secondary: secondaryLang)
		}
		
	}
	
	private func saveCurrentDirection() {
		guard let currentDirection = currentDirection else { return }
		UserDefaults.standard.set(currentDirection.primary.code, forKey: "primary")
		UserDefaults.standard.set(currentDirection.secondary.code, forKey: "secondary")
		print("successfully set \(currentDirection.primary.code ?? "") for primary and \(currentDirection.secondary.code ?? "") for secondary")
	}
	
	func translate(text: String) {
		guard let currentDirection = currentDirection else { return }
		interactor?.translate(text: text, direction: currentDirection, completion: { [weak self] (text) in
			if let text = text, !text.isEmpty {
				self?.view?.setTranslation(text: text)
			}
		})
	}
	
	func handleTapNavBar(tag: Int) {
		switch tag {
		case 0:
			router?.push(.changeLang(primary: true))
		case 1:
			guard let currentDirection = currentDirection else { return }
			
			let newDirection = Direction(primary: currentDirection.secondary, secondary: currentDirection.primary)
			self.currentDirection = newDirection
			
//			view?.updateNavBar(direction: currentDirection)
		case 2:
			router?.push(.changeLang(primary: false))
		default:
			break
		}
	}
	
}
