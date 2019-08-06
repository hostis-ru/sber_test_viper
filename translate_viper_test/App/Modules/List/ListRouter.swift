//
//  ListRouter.swift
//  translate_viper_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import UIKit

class ListRouter: NSObject, Router {
	
	var baseRouter: BaseRouter?
	
	var childRouters = [Router]()
	
	var navigationController: UINavigationController?
	var rootVC: UIViewController?
	weak var presenter: ListPresenter?
	
	func start() {
		
		let vc = ListViewController()
		vc.title = "Список"
		
		let interactor = ListInteractor()
		let presenter = ListPresenter(router: self)
		self.presenter		 = presenter
		
		presenter.view       = vc
		presenter.interactor = interactor
		
		navigationController?.pushViewController(vc, animated: false)
	}
	
	func push(_ destination: Destination) {
		switch destination {
		case .translation(let dict):
			let translateRouter = TranslateRouter(navigationController!)
			translateRouter.start()
			translateRouter.presenter?.modal = true
			translateRouter.presenter?.setTranslation(dict: dict)
			
		default:
			break
		}
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
