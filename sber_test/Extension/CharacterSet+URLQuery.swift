//
//  CharacterSet+URLQuery.swift
//  sber_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

extension CharacterSet {
	static let urlQueryValueAllowed: CharacterSet = {
		let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
		let subDelimitersToEncode = "!$&'()*+,;="
		
		var allowed = CharacterSet.urlQueryAllowed
		allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		return allowed
	}()
}
