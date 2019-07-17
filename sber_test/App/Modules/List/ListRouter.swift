//
//  ListRouter.swift
//  sber_test
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
	
	func start() {
		
		let vc = ListViewController()
		vc.title = "Список"
		
		let interactor = ListInteractor()
		let presenter = ListPresenter(router: self)
		
		presenter.view       = vc
		presenter.interactor = interactor
		
		navigationController?.pushViewController(vc, animated: false)
	}
	
	
	init(_ navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
}
