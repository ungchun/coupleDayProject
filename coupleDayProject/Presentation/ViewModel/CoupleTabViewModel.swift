import UIKit

final class CoupleTabViewModel {
	
	init() {
		updateBeginCoupleDay()
		updateHomeMainImage()
		updateMyProfileIcon()
		updatePartnerProfileIcon()
	}
	
	//MARK: - Properties
	
	var beginCoupleDay: Observable<String> = Observable("")
	var homeMainImageData: Observable<Data> = Observable((
		UIImage(
			named: "coupleImg"
		)?.jpegData(compressionQuality: 0.5)
	)!)
	var myProfileImageData: Observable<Data> = Observable((
		UIImage(
			named: "smile_dark"
		)?.jpegData(compressionQuality: 0.5)
	)!)
	var partnerProfileImageData: Observable<Data> = Observable((
		UIImage(
			named: "smile_dark"
		)?.jpegData(compressionQuality: 0.5)
	)!)
	
	//MARK: - Functions
	
	func updateBeginCoupleDay() {
		let nowDayDataString = Date().toString
		let nowDayDataDate: Date = nowDayDataString.toDate
		let minus = Int(nowDayDataDate.millisecondsSince1970)-RealmService.shared.getUserDatas().first!.beginCoupleDay
		self.beginCoupleDay.value = String(describing: minus / 86400000)
		
		NotificationCenter.default.post(
			name: Notification.Name.coupleDay,
			object: nil,
			userInfo: ["coupleDay": self.beginCoupleDay.value]
		)
	}
	
	func updateHomeMainImage() {
		guard let homeMainImage = RealmService.shared.getImageDatas().first!.homeMainImage else { return }
		self.homeMainImageData.value = homeMainImage
	}
	
	func updateMyProfileIcon() {
		let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
		if RealmService.shared.getImageDatas().first!.myProfileImage == nil {
			if isDark {
				self.myProfileImageData.value = (UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!
			} else {
				self.myProfileImageData.value = (UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5))!
			}
		} else {
			self.myProfileImageData.value = RealmService.shared.getImageDatas().first!.myProfileImage!
		}
	}
	
	func updatePartnerProfileIcon() {
		let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
		if RealmService.shared.getImageDatas().first!.partnerProfileImage == nil {
			if isDark {
				self.partnerProfileImageData.value = (UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!
			} else {
				self.partnerProfileImageData.value = (UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5))!
			}
		} else {
			self.partnerProfileImageData.value = RealmService.shared.getImageDatas().first!.partnerProfileImage!
		}
	}
}
