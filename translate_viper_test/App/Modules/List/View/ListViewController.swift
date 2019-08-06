//
//  ListViewController.swift
//  translate_viper_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import UIKit

protocol ListViewProtocol: class {
	
	var presenter: ListPresenterProtocol? { get set }
	
	func reloadData()
}

class ListViewController: UIViewController, ListViewProtocol {
	
	var presenter: ListPresenterProtocol?
	
	var tableView: UITableViewController?
	var searchBar: UISearchBar = {
		let searchBar = UISearchBar()
        searchBar.placeholder  = "Search"
        searchBar.barTintColor = .white
		searchBar.backgroundColor = .white
		searchBar.backgroundImage = UIImage()
		
		
		return searchBar
	}()
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
		
		let rightButton = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(deleteItems))
		navigationItem.rightBarButtonItem = rightButton
		
		searchBar.delegate = self
		
		setupTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		presenter?.fetchData()
	}
	
	func reloadData() {
		if let tableView = tableView as? GenericTableViewController<Dict, Value1TableViewCell>, let data = presenter?.currentData {
			tableView.items = data
			tableView.tableView.reloadData()
		}
	}
	
	func setupTableView() {
		tableView = GenericTableViewController(items: presenter?.currentData ?? [], configure: { (cell: Value1TableViewCell, item: Dict) in
//			print("item: \(item.secondaryWord)")
			cell.textLabel?.text = "\(item.primaryWord ?? "")"
			cell.detailTextLabel?.text = "\(item.secondaryWord ?? "")"
		}, selectHandler: { [weak self] (dict) in
			self?.presenter?.handleDidSelect(item: dict)
		})
		guard let tableView = tableView else {
			return
		}
		tableView.tableView.tableFooterView = UIView()
		
		
		let stackView = UIStackView(arrangedSubviews: [
				searchBar, tableView.view
			])
		stackView.axis = .vertical
		
		self.addChild(tableView)
		tableView.didMove(toParent: self)
		
		view.addSubview(stackView)
		stackView.fillSuperview()
	}
	
	@objc func deleteItems(_ sender: Any?) {
		presenter?.deleteItems()
	}
}

extension ListViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		presenter?.handleSearchDidChange(text: searchText)
	}
}

extension ListViewController {
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		searchBar.resignFirstResponder()
		self.searchBar.endEditing(true)
	}
}
