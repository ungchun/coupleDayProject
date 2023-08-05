import Foundation

import RxSwift
import RxCocoa
import RxRelay

final class HomeViewModel {
	
	struct Input {
		var appNameLabelTrigger = PublishSubject<String>()
	}
	
	struct Output {
		let appNameLabelOutput = BehaviorSubject<String>(value: "너랑나랑")
	}
	
	let input = Input()
	let output = Output()
	
	//MARK: - Properties
	
	private var changeLabelInitCheck = false
	private var appNameDayToggleFlag = false
	private var changeLabelTimer = Timer()
	private var receivedCoupleDayData = "너랑나랑"
	
	private let disposeBag = DisposeBag()
	
	//MARK: - Functions
	
	init() {
		bind()
		changeAppNameLabel()
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(receiveCoupleDayData(notification:)),
			name: Notification.Name.coupleDay, object: nil
		)
	}
	
	private func changeAppNameLabel() {
		let nowDayDataString = Date().toString
		let nowDayDataDate: Date = nowDayDataString.toDate
		let minus = Int(nowDayDataDate.millisecondsSince1970)-RealmService.shared.getUserDatas().first!.beginCoupleDay
		receivedCoupleDayData = String(describing: minus / 86400000)
		
		if !changeLabelInitCheck {
			changeLabelTimer = Timer.scheduledTimer(
				timeInterval: 5,
				target: self,
				selector: #selector(updateLabel),
				userInfo: nil,
				repeats: true
			)
			changeLabelInitCheck = true
		}
	}
	
	private func bind() {
		self.input.appNameLabelTrigger
			.bind { [weak self] value in
				self?.output.appNameLabelOutput.onNext(value)
			}
			.disposed(by: disposeBag)
	}
	
	@objc private func updateLabel() {
		if appNameDayToggleFlag {
			self.input.appNameLabelTrigger.onNext("\(String(describing: self.receivedCoupleDayData)) days")
		} else {
			self.input.appNameLabelTrigger.onNext("너랑나랑")
		}
		
		appNameDayToggleFlag.toggle()
	}
	
	@objc private func receiveCoupleDayData(notification: Notification) {
		guard let object = notification.userInfo?["coupleDay"] as? String else { return }
		receivedCoupleDayData = object
	}
}
