//
//  PlaceDTO.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/25.
//

import Foundation

struct PlaceDTO {
	let id: String?
	let modifyState: Bool?
	let address: String?
	let shortAddress: String?
	let introduce: Array<String>?
	let imageUrl: Array<String>?
	let latitude: String?
	let longitude: String?
}

extension PlaceDTO {
	func toEntity() -> Place {
		return Place(
			placeName: id ?? "",
			address: address ?? "",
			shortAddress: shortAddress ?? "",
			introduce: introduce ?? [],
			imageUrl: imageUrl ?? [],
			latitude: latitude ?? "",
			longitude: longitude ?? "",
			modifyStateCheck: modifyState ?? false
		)
	}
}
