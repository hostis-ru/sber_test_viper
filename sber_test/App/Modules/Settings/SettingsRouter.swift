//
//  SettingsRouter.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import UIKit

class SettingsRouter: NSObject, Router {
	
	var baseRouter: BaseRouter?
	
	var childRouters = [Router]()
	
	var navigationController: UINavigationController?
	var rootVC: UIViewController?
	weak var presenter: SettingsPresenter?
	
	func start() {
		
        let vc   = SettingsViewController()
		rootVC = vc
        vc.title = "Настройки"
		
        let interactor       = SettingsInteractor()
        let presenter        = SettingsPresenter(router: self)
        self.presenter       = presenter

        presenter.view       = vc
        presenter.interactor = interactor
		
		navigationController?.pushViewController(vc, animated: true)
	}
	
	
	init(_ navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
}
