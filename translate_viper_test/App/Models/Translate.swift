//
//  Translate.swift
//  translate_viper_test
//
//  Created by Denis on 17/07/2019.
//  Copyright © 2019 hostis. All rights reserved.
//

import Foundation

struct Direction {
		
	var primary: Langs
	var secondary: Langs
	
	var description: String {
		return "\(primary.code ?? "")-\(secondary.code ?? "")"
	}
}

struct Translation {
	
	var direction: Direction
	var primaryWord: String
	var secondaryWord: String
}

