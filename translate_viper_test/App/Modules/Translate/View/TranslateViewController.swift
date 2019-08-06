//
//  TranslateViewController.swift
//  translate_viper_test
//
//  Created by Denis on 16/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import UIKit

protocol TranslateViewProtocol: class {
	
	var presenter: TranslatePresenterProtocol? { get set }
	
	func setTranslation(origin: String?, translation: String)
	func updateNavBar(direction: Direction)
	func blockUI()
	func getCurrentWord() -> String?
	func switchWords()
}

class TranslateViewController: UIViewController, TranslateViewProtocol {
	
	var presenter: TranslatePresenterProtocol?
	
	var textField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Введите слово"
		
		textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: .editingDidEnd)
		return textField
	}()
	
	var translateLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.sizeToFit()
		
		return label
	}()
	
	var navBarPrimaryLangBtn: UIButton = {
		let button =  UIButton(type: .custom)
		button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
		button.backgroundColor = .clear
		button.setTitle("Установить язык", for: .normal)
		button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
		button.tag = 0
		
		return button
	}()
	
	var navBarSecondaryLangBtn: UIButton = {
		let button =  UIButton(type: .custom)
		button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
		button.backgroundColor = .clear
		button.setTitle("Установить язык", for: .normal)
		button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
		button.tag = 2
		
		return button
	}()
	
	var navBarSwitchBtn: UIButton = {
		let button =  UIButton(type: .custom)
		button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		button.backgroundColor = .clear
		button.setTitle("  <->  ", for: .normal)
		button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
		button.tag = 1
		
		return button
	}()
	
	private let throttler = Throttler(minimumDelay: 0.2)
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
		
		setupView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		presenter?.setDirection()		
	}
	
	func setupView() {
		
		let stack = UIStackView(arrangedSubviews: [navBarPrimaryLangBtn, navBarSwitchBtn, navBarSecondaryLangBtn])
		navBarPrimaryLangBtn.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
		navBarSwitchBtn.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
		navBarSecondaryLangBtn.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
		navigationItem.titleView = stack
		
		let innerView = UIView(frame: view.frame)
		innerView.backgroundColor = .white
		
		innerView.layer.cornerRadius = 45
		innerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
		
		view.addSubview(innerView)
		innerView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
		
		let border = UIView()
		border.backgroundColor = .black
		border.constrainHeight(constant: 1)
		border.constrainWidth(constant: innerView.bounds.width*0.8)
		
		let stackView = UIStackView(arrangedSubviews: [
				textField, border, translateLabel
			])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.setCustomSpacing(10, after: border)
		
		textField.constrainWidth(constant: innerView.bounds.width*0.8)
		textField.constrainHeight(constant: 100)
		translateLabel.constrainWidth(constant: innerView.bounds.width*0.8)
		
		innerView.addSubview(stackView)
		stackView.constrainWidth(constant: innerView.bounds.width - 40, priority: 900)
		stackView.constrainHeight(constant: 150)
		
	}
	
	func updateNavBar(direction: Direction) {
		print("updating nav bar with primary: \(direction.primary.desc ?? ""), secondary: \(direction.secondary.desc ?? "")")
		navBarPrimaryLangBtn.setTitle(direction.primary.desc, for: .normal)
		navBarSecondaryLangBtn.setTitle(direction.secondary.desc, for: .normal)
		
	}
	
	func getCurrentWord() -> String? {
		guard let text = textField.text, !text.isEmpty else { return nil }
		return text
	}
	
	func switchWords() {
		if let origin = textField.text, !origin.isEmpty, let translation = translateLabel.text, !translation.isEmpty {
			textField.text = translation
			translateLabel.text = origin
		}
	}
	
	@objc func textFieldEditingDidEnd(_ sender: Any) {
		// api call
		guard let text = textField.text, !text.isEmpty else {
			setTranslation(origin: nil, translation: "")
			return
		}
		presenter?.translate(text: text)
	}
	
	// nav bar actions
	@objc func clickOnButton(_ sender: Any) {
		print("tap")
		if let sender = sender as? UIButton {
			throttler.throttle { [weak self] in
				self?.presenter?.handleTapNavBar(tag: sender.tag)
			}
			
		}
	}
	
	// set ui with translation
	func setTranslation(origin: String?, translation: String) {
		if let origin = origin {
			textField.text = origin
		}
		translateLabel.text = translation
	}
	
	// block ui if we call Translation VC from List VC
	func blockUI() {
		textField.isEnabled = false
		translateLabel.isEnabled = false
		navBarPrimaryLangBtn.isEnabled = false
		navBarSecondaryLangBtn.isEnabled = false
		navBarSwitchBtn.isEnabled = false
	}
}
