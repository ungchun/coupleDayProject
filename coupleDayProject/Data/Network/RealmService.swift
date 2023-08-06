//
//  RealmService.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/25.
//

import Photos
import UIKit
import WidgetKit

import RealmSwift

protocol RealmInterface {
	func getUserDatas() -> [User]
	func getImageDatas() -> [HomeImage]
	func writeUserData(userData: User) -> Void
	func writeImageData(imageData: HomeImage) -> Void
	func updateBeginCoupleDay(datePicker: UIDatePicker) -> Void
	func updateBirthDay(datePicker: UIDatePicker) -> Void
	func updateMainImage(mainImage: UIImage) -> Void
	func updateMyProfileImage(myProfileImage: UIImage) -> Void
	func updatePartnerProfileImage(partnerProfileImage: UIImage) -> Void
}

final class RealmService: RealmInterface {
	// try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
	
	static let shared = RealmService()
	
	private var realm: Realm {
		let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ungchun.coupleDayProject")
		let realmURL = container?.appendingPathComponent("default.realm")
		let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
		do {
			return try Realm(configuration: config)
		} catch _ {
			fatalError(RealmError.noRealmavailable.localizedDescription)
		}
	}
	
	func getUserDatas() -> [User] {
		Array(realm.objects(User.self))
	}
	
	func getImageDatas() -> [HomeImage] {
		Array(realm.objects(HomeImage.self))
	}
	
	func writeUserData(userData: User) {
		try? realm.write({
			realm.add(userData)
		})
	}
	
	func writeImageData(imageData: HomeImage) {
		try? realm.write({
			realm.add(imageData)
		})
	}
	
	// 확인
	func updateBeginCoupleDay(datePicker: UIDatePicker) {
		try? realm.write({
			if let userDatas = RealmService.shared.getUserDatas().first {
				if userDatas.zeroDayStartCheck {
					userDatas.beginCoupleDay = Int(datePicker.date.toString.toDate.millisecondsSince1970)
				} else {
					userDatas.beginCoupleDay = Int(
						Calendar.current.date(
							byAdding: .day,
							value: -1,
							to: datePicker.date.toString.toDate
						)?.millisecondsSince1970 ?? 0
					)
				}
			}
		})
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	func updateBirthDay(datePicker: UIDatePicker) {
		initBirthDayAnniversary(
			dateValue: Int(datePicker.date.toString.toDate.millisecondsSince1970)
		)
		try? realm.write({
			if let userDatas = RealmService.shared.getUserDatas().first {
				userDatas.birthDay = Int(datePicker.date.toString.toDate.millisecondsSince1970)
			}
		})
	}
	
	func updateMainImage(mainImage: UIImage) {
		try? realm.write({
			if let imageDatas = RealmService.shared.getImageDatas().first {
				imageDatas.homeMainImage =
				(mainImage.pngData()?.count) ?? 0 > 10000000
				? resizeImage(image: mainImage, newWidth: 1000).pngData()
				: mainImage.jpegData(compressionQuality: 0.5)
			}
		})
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	func updateMyProfileImage(myProfileImage: UIImage) {
		try? realm.write({
			if let imageDatas = RealmService.shared.getImageDatas().first {
				imageDatas.myProfileImage =
				(myProfileImage.pngData()?.count) ?? 0 > 10000000
				? resizeImage(image: myProfileImage, newWidth: 1000).pngData()
				: myProfileImage.jpegData(compressionQuality: 0.5)
			}
		})
	}
	
	func updatePartnerProfileImage(partnerProfileImage: UIImage) {
		try? realm.write({
			if let imageDatas = RealmService.shared.getImageDatas().first {
				imageDatas.partnerProfileImage =
				(partnerProfileImage.pngData()?.count) ?? 0 > 10000000
				? resizeImage(image: partnerProfileImage, newWidth: 1000).pngData()
				: partnerProfileImage.jpegData(compressionQuality: 0.5)
			}
		})
	}
}
