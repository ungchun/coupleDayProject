import Foundation
import UIKit

final class CoupleTabViewModel {
    
    init() {
        updateBeginCoupleDay()
        updateHomeMainImage()
        updateMyProfileIcon()
        updatePartnerProfileIcon()
    }
    
    // MARK: Properties
    //
    var beginCoupleDay: Observable<String> = Observable("") // 날짜
    var homeMainImageData: Observable<Data> = Observable((UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5))!)
    var myProfileImageData: Observable<Data> = Observable((UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!)
    var partnerProfileImageData: Observable<Data> = Observable((UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!)
    
    // MARK: Functions
    //
    func updateBeginCoupleDay() {
        let nowDayDataString = Date().toString
        let nowDayDataDate: Date = nowDayDataString.toDate
        let minus = Int(nowDayDataDate.millisecondsSince1970)-RealmManager.shared.getUserDatas().first!.beginCoupleDay // 현재 - 사귄날짜 = days
        self.beginCoupleDay.value = String(describing: minus / 86400000)
        
        // NotificationCenter로 Post하기 (발송하기)
        //
        NotificationCenter.default.post(name: Notification.Name.coupleDay, object: nil, userInfo: ["coupleDay": self.beginCoupleDay.value])
    }
    
    func updateHomeMainImage() {
        guard let homeMainImage = RealmManager.shared.getImageDatas().first!.homeMainImage else { return }
        self.homeMainImageData.value = homeMainImage
    }
    
    func updateMyProfileIcon() {
        let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
        if RealmManager.shared.getImageDatas().first!.myProfileImage == nil {
            if isDark {
                self.myProfileImageData.value = (UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!
            } else {
                self.myProfileImageData.value = (UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5))!
            }
        } else {
            self.myProfileImageData.value = RealmManager.shared.getImageDatas().first!.myProfileImage!
        }
    }
    
    func updatePartnerProfileIcon() {
        let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
        if RealmManager.shared.getImageDatas().first!.partnerProfileImage == nil {
            if isDark {
                self.partnerProfileImageData.value = (UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5))!
            } else {
                self.partnerProfileImageData.value = (UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5))!
            }
        } else {
            self.partnerProfileImageData.value = RealmManager.shared.getImageDatas().first!.partnerProfileImage!
        }
    }
}

// ViewModel DataBinding Observable
//
final class Observable<T> {
    // 3) 호출되면, 2번에서 받은 값을 전달한다.
    //
    private var listener: ((T) -> Void)?
    
    // 2) 값이 set되면, listener에 해당 값을 전달한다,
    //
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // 1) 초기화함수를 통해서 값을 입력받고, 그 값을 "value"에 저장한다.
    //
    init(_ value: T) {
        self.value = value
    }
    
    // 4) 다른 곳에서 bind라는 메소드를 호출하게 되면,
    // value에 저장했던 값을 전달해주고,
    // 전달받은 "closure" 표현식을 listener에 할당한다.
    //
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
