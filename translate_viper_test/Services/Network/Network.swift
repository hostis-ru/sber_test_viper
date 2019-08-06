//
//  Network.swift
//  translate_viper_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case failInternetError
	case noInternetConnection
}

class NetworkService {
	
	private init() {}
	
	static let shared = NetworkService()
	
	func getData(url: URL, completion: @escaping (Any) -> ()) {
		let session = URLSession.shared
		
		session.dataTask(with: url) { (data, response, error) in
			guard let data = data else { return }
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				DispatchQueue.main.async {
					completion(json)
				}
			} catch {
				print(error)
			}
			}.resume()
	}
	
	func postData(urlRequest: URLRequest, completion: @escaping (Any) -> ()) {
		let session = URLSession.shared
		
		session.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data else { return }
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				DispatchQueue.main.async {
					completion(json)
				}
			} catch {
				print(error)
			}
			}.resume()
	}
}
