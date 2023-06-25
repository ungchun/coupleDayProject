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
	
}

enum RealmError: Error {
	case noData
	case noRealmavailable
	case exception(errorMessage: String)
}

final class RealmService: RealmInterface {
	//         try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
	
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
	
	func getUserDatas() -> [RealmUserModel] {
		Array(realm.objects(RealmUserModel.self))
	}
	
	func getImageDatas() -> [RealmImageModel] {
		Array(realm.objects(RealmImageModel.self))
	}
	
	func writeUserData(userData: RealmUserModel) {
		try? realm.write({
			realm.add(userData)
		})
	}
	
	func writeImageData(imageData: RealmImageModel) {
		try? realm.write({
			realm.add(imageData)
		})
	}
	
	func updateBeginCoupleDay(datePicker: UIDatePicker) {
		try? realm.write({
			if RealmService.shared.getUserDatas().first!.zeroDayStartCheck {
				RealmService.shared.getUserDatas().first!.beginCoupleDay = Int(datePicker.date.toString.toDate.millisecondsSince1970)
			} else {
				RealmService.shared.getUserDatas().first!.beginCoupleDay = Int(
					Calendar.current.date(
						byAdding: .day,
						value: -1,
						to: datePicker.date.toString.toDate
					)!.millisecondsSince1970
				)
			}
		})
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	func updateBirthDay(datePicker: UIDatePicker) {
		initBirthDayAnniversaryModel(
			dateValue: Int(datePicker.date.toString.toDate.millisecondsSince1970)
		)
		try? realm.write({
			RealmService.shared.getUserDatas().first!.birthDay = Int(datePicker.date.toString.toDate.millisecondsSince1970)
		})
	}
	
	func updateMainImage(mainImage: UIImage) {
		try? realm.write({
			RealmService.shared.getImageDatas().first!.homeMainImage =
			(mainImage.pngData()?.count)! > 10000000
			? resizeImage(image: mainImage, newWidth: 1000).pngData()
			: mainImage.jpegData(compressionQuality: 0.5)
		})
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	func updateMyProfileImage(myProfileImage: UIImage) {
		try? realm.write({
			RealmService.shared.getImageDatas().first!.myProfileImage =
			(myProfileImage.pngData()?.count)! > 10000000
			? resizeImage(image: myProfileImage, newWidth: 1000).pngData()
			: myProfileImage.jpegData(compressionQuality: 0.5)
		})
	}
	
	func updatePartnerProfileImage(partnerProfileImage: UIImage) {
		try? realm.write({
			RealmService.shared.getImageDatas().first!.partnerProfileImage = (partnerProfileImage.pngData()?.count)! > 10000000
			? resizeImage(image: partnerProfileImage, newWidth: 1000).pngData() : partnerProfileImage.jpegData(compressionQuality: 0.5)
		})
	}
}
