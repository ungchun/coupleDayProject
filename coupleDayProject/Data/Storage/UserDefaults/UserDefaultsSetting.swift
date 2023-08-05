//
//  UserDefaultsSetting.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/08/05.
//

import Foundation

enum UserDefaultsSetting {
	
	@UserDefaultsWrapper(key: "darkModeState", defaultValue: false)
	static var isDarkMode
	
}
