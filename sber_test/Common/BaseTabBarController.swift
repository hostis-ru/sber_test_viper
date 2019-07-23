//
//  BaseTabBarController.swift
//  sber_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

	var router: BaseRouter
	
	init(with router: BaseRouter) {
		self.router = router
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewControllers = router.controllers
		
		
	}
	
}
