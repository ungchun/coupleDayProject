//
//  RealmError.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/08/05.
//

import Foundation

enum RealmError: Error {
	case noData
	case noRealmavailable
	case exception(errorMessage: String)
}
