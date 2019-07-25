//
//  TranslateRouter.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import UIKit

class TranslateRouter: NSObject, Router {
	
	var baseRouter: BaseRouter?
	
	var childRouters = [Router]()
	
	var navigationController: UINavigationController?
	var rootVC: UIViewController?
	weak var presenter: TranslatePresenter?
	
	func start() {
		
        let vc   = TranslateViewController()
        vc.title = "Перевод"
		
        let interactor       = TranslateInteractor()
        let presenter        = TranslatePresenter(router: self)
		self.presenter		 = presenter
		
        presenter.view       = vc
        presenter.interactor = interactor
		
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func push(_ destination: Destination) {
		switch destination {
		case .changeLang(let primary):
			
			let settingsRouter = SettingsRouter(navigationController!)
			settingsRouter.start()
			
			if primary {
				settingsRouter.rootVC?.title = "Выбор основного языка"
				settingsRouter.presenter?.chooseLangHandler = { [unowned self] (lang) in
					print("chosen language is \(lang.code ?? ""), \(lang.desc ?? "")")
					self.presenter?.handleLangSelection(primary: lang, secondary: nil)
					self.pop()
				}
			} else {
				settingsRouter.rootVC?.title = "Выбор языка перевода"
				settingsRouter.presenter?.chooseLangHandler = { [unowned self] (lang) in
					self.presenter?.handleLangSelection(primary: nil, secondary: lang)
					self.pop()
				}
			}
			print("1")
		default:
			break
		}
	}
	
	func pop() {
		navigationController?.popViewController(animated: true)
	}
	
	
	init(_ navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func childDidFinish(_ child: Router?) {
		for (index, coordinator) in childRouters.enumerated() {
			if coordinator === child {
				childRouters.remove(at: index)
				break
			}
		}
	}
	
}
