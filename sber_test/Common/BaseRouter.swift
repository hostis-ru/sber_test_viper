//
//  BaseRouter.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
	case changeLang(primary: Bool)
	
}

protocol Router: AnyObject {
	
	var childRouters: [Router] { get set }
	var navigationController: UINavigationController? { get set }
	var rootVC: UIViewController? { get set }
	
	func start()
	func dismiss()
}

extension Router {
	func dismiss() {
		return
	}
}

class BaseRouter: NSObject, Router {
	
	var childRouters = [Router]()
	var controllers = [UIViewController]()
	
	// set here previous navigationController, so we can popToRoot it when deinit this part of app
	weak var navigationController: UINavigationController?
	var rootVC: UIViewController?
	
	func start() {
		
		let translateNav = createNavController( title: "", imageName: "translation")
		let translateRouter = TranslateRouter(translateNav)
		translateRouter.baseRouter = self
		
		let listNav = createNavController( title: "", imageName: "list")
		let listRouter = ListRouter(listNav)
		listRouter.baseRouter = self
		
		let settingsNav = createNavController( title: "", imageName: "settings")
		let settingsRouter = SettingsRouter(settingsNav)
		settingsRouter.baseRouter = self
		
		controllers.append(translateNav)
		controllers.append(listNav)
		controllers.append(settingsNav)
		
		childRouters.append(translateRouter)
		childRouters.append(listRouter)
		childRouters.append(settingsRouter)
		
		translateRouter.start()
		listRouter.start()
		settingsRouter.start()
		
		
	}
	
	func push(_ destination: Destination) {
		switch destination {
			
		default:
			break
		}
	}
	
	func dismiss() {
		rootVC?.dismiss(animated: true, completion: nil)
	}
	
	
	fileprivate func createNavController(title: String, imageName: String) -> UINavigationController {
		
		//		vc.title = title
		
		let navController  = UINavigationController()
		
		let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
		navController.navigationBar.titleTextAttributes = textAttributes
		
		navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navController.navigationBar.shadowImage = UIImage()
		
		
		
		navController.navigationBar.barStyle      = .default
		navController.navigationBar.tintColor     = .black
		navController.navigationBar.barTintColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
		navController.navigationBar.isTranslucent = false
		
		navController.tabBarItem.title                 = title
		navController.tabBarItem.image                 = UIImage(named: imageName)
		navController.navigationBar.prefersLargeTitles = false
		
		
		return navController
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
