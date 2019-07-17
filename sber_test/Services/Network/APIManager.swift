//
//  APIManager.swift
//  sber_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

class APIManager {
	private init() {}
	
	
	static func getLanguages(completion: @escaping([String:Any]) -> ()) {
		guard let url = URL(string: "https://translate.yandex.net/api/v1.5/tr.json/getLangs") else { return }
		
		var request = URLRequest(url: url)
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		let parameters: [String: Any] = [
			"ui": "ru",
			"key": "trnsl.1.1.20190717T100218Z.a19baa4f59cc0ad0.c73c2dd355d3a2948be6ac1f22ebb9efb0511652"
		]
		request.httpBody = parameters.percentEscaped().data(using: .utf8)
		
		NetworkService.shared.postData(urlRequest: request) { (json) in
			do {
				guard let response = json as? [String:Any] else { return }
//				print(json)
				completion(response)
			} catch {
				print(error)
			}
		}
	}
	
	static func translate(text: String, direction: Direction, completion: @escaping([String:Any]) -> ()) {
		guard let url = URL(string: "https://translate.yandex.net/api/v1.5/tr.json/translate") else { return }
		
		var request = URLRequest(url: url)
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		let parameters: [String: Any] = [
			"key": "trnsl.1.1.20190717T100218Z.a19baa4f59cc0ad0.c73c2dd355d3a2948be6ac1f22ebb9efb0511652",
			"text": text,
			"lang": direction.description
		]
		request.httpBody = parameters.percentEscaped().data(using: .utf8)
		
		NetworkService.shared.postData(urlRequest: request) { (json) in
			do {
				guard let response = json as? [String:Any] else { return }
//				print(json)
				completion(response)
			} catch {
				print(error)
			}
		}
	}
}
