//
//  SettingsViewController.swift
//  translate_viper_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import UIKit

protocol SettingsViewProtocol: class {
	
	var presenter: SettingsPresenterProtocol? { get set }
	var chooseLangHandler: ((Langs) -> ())? { get set }
	
	func setupTableView()
	
}

class SettingsViewController: UIViewController, SettingsViewProtocol {
	
	var presenter: SettingsPresenterProtocol?
	
	var tableView: UITableViewController?
	var chooseLangHandler: ((Langs) -> ())? {
		didSet {
			if let tableView = tableView as? GenericTableViewController<Langs, UITableViewCell> {
				tableView.selectHandler = self.chooseLangHandler!
			}
		}
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		
	}
	
	func setupTableView() {
		tableView = GenericTableViewController(items: presenter?.data ?? [], configure: { (cell: UITableViewCell, item: Langs) in
			cell.textLabel?.text = item.desc
		}, selectHandler: chooseLangHandler ?? { _ in })
		guard let tableView = tableView else {
			return
		}
		view.addSubview(tableView.view)
		tableView.view.fillSuperview()
	}
	
}
