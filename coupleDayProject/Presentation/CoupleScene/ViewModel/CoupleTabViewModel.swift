import UIKit

import RxSwift
import RxCocoa
import RxRelay

final class CoupleTabViewModel {
	
	struct Input {
		var beginCoupleDayTrigger = PublishSubject<Void>()
		var homeMainImageDataTrigger = PublishSubject<Void>()
		var myProfileImageDataTrigger = PublishSubject<Void>()
		var partnerProfileImageDataTrigger = PublishSubject<Void>()
	}
	
	struct Output {
		let beginCoupleDayOutput = BehaviorRelay<String>(value: "")
		let homeMainImageDataOutput = BehaviorRelay<Data>(value: (UIImage(
			named: "coupleImg"
		)?.jpegData(compressionQuality: 0.5))!)
		let myProfileImageDataOutput = BehaviorSubject<Data>(value: (UIImage(
			named: "smile_dark"
		)?.jpegData(compressionQuality: 0.5))!)
		let partnerProfileImageDataOutput = BehaviorSubject<Data>(value: (UIImage(
			named: "smile_dark"
		)?.jpegData(compressionQuality: 0.5))!)
	}
	
	let input = Input()
	let output = Output()
	
	private let disposeBag = DisposeBag()
	
	init() {
		bind()
	}
	
	//MARK: - Functions
	
	private func bind() {
		self.input.beginCoupleDayTrigger
			.bind { [weak self] in
				let nowDayDataString = Date().toString
				let nowDayDataDate: Date = nowDayDataString.toDate
				let minus = Int(nowDayDataDate.millisecondsSince1970)-RealmService.shared.getUserDatas().first!.beginCoupleDay
				let dayValue = String(describing: minus / 86400000)
				self?.output.beginCoupleDayOutput.accept(dayValue)
				
				NotificationCenter.default.post(
					name: Notification.Name.coupleDay,
					object: nil,
					userInfo: ["coupleDay": dayValue]
				)
			}
			.disposed(by: disposeBag)
		
		self.input.homeMainImageDataTrigger
			.bind { [weak self] in
				guard let homeMainImage = RealmService.shared.getImageDatas().first!.homeMainImage else { return }
				self?.output.homeMainImageDataOutput.accept(homeMainImage)
			}
			.disposed(by: disposeBag)
		
		self.input.myProfileImageDataTrigger
			.bind { [weak self] in
				let isDarkMode = UserDefaultsSetting.isDarkMode
				if RealmService.shared.getImageDatas().first!.myProfileImage == nil {
					if isDarkMode {
						self?.output.myProfileImageDataOutput.onNext((UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!)
					} else {
						self?.output.myProfileImageDataOutput.onNext((UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5))!)
					}
				} else {
					self?.output.myProfileImageDataOutput.onNext(RealmService.shared.getImageDatas().first!.myProfileImage!)
				}
			}
			.disposed(by: disposeBag)
		
		self.input.partnerProfileImageDataTrigger
			.bind { [weak self] in
				let isDarkMode = UserDefaultsSetting.isDarkMode
				if RealmService.shared.getImageDatas().first!.partnerProfileImage == nil {
					if isDarkMode {
						self?.output.partnerProfileImageDataOutput.onNext((UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!)
					} else {
						self?.output.partnerProfileImageDataOutput.onNext((UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5))!)
					}
				} else {
					self?.output.partnerProfileImageDataOutput.onNext(RealmService.shared.getImageDatas().first!.partnerProfileImage!)
				}
			}
			.disposed(by: disposeBag)
		
		self.input.beginCoupleDayTrigger.onNext(())
		self.input.homeMainImageDataTrigger.onNext(())
		self.input.myProfileImageDataTrigger.onNext(())
		self.input.partnerProfileImageDataTrigger.onNext(())
	}
}
