//
//  Dictionary+PercentEscaped.swift
//  translate_viper_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

extension Dictionary {
	func percentEscaped() -> String {
		return map { (key, value) in
			let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			return escapedKey + "=" + escapedValue
			}
			.joined(separator: "&")
	}
}
