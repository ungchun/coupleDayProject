import Foundation
import UIKit

class CoupleTabViewModel {
    
    init() { }
    
    static var publicBeginCoupleDay = ""
    static var publicBeginCoupleFormatterDay = ""
    static var changeMainImageCheck = false
    static var changeCoupleDayMainCheck = false
    static var changeCoupleDayStoryCheck = false
    static var changeDarkModeCheck = false
    
    var onMainImageDataUpdated: () -> Void = {} // 메인 이미지 변경 시
    var onMyProfileImageDataUpdated: () -> Void = {} // 내 프로필사진 변경 시
    var onPartnerProfileImageDataUpdated: () -> Void = {} // 상대방 프로필사진 변경 시
    
    var onPublicBeginCoupleFormatterDayUpdated: () -> Void = {} // 날짜 변경 시 story date -> yyyy.MM.dd 형식 update
    var onPublicBeginCoupleDayUpdated: () -> Void = {} // 날짜 변경 시 day update
    
    var mainImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5) {
        didSet {
            onMainImageDataUpdated()
        }
    }
    var myProfileImageData = UIImage(named: "smile_black")?.jpegData(compressionQuality: 0.5) {
        didSet {
            onMyProfileImageDataUpdated()
        }
    }
    var partnerProfileImageData = UIImage(named: "smile_black")?.jpegData(compressionQuality: 0.5) {
        didSet {
            onPartnerProfileImageDataUpdated()
        }
    }
    var beginCoupleFormatterDay = "" {
        didSet {
            onPublicBeginCoupleFormatterDayUpdated()
        }
    }
    var beginCoupleDay = "" {
        didSet {
            onPublicBeginCoupleDayUpdated()
        }
    }

    
    // MARK: func
    //
    // 날짜 세팅
    //
    func setBeginCoupleDay() {
        let nowDayDataString = Date().toString
        let nowDayDataDate: Date = nowDayDataString.toDate
        let minus = Int(nowDayDataDate.millisecondsSince1970)-RealmManager.shared.getUserDatas().first!.beginCoupleDay // 현재 - 사귄날짜 = days
        self.beginCoupleDay = String(describing: minus / 86400000)
        CoupleTabViewModel.publicBeginCoupleDay = String(describing: minus / 86400000)
        self.beginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(RealmManager.shared.getUserDatas().first!.beginCoupleDay) / 1000).toStoryString
        CoupleTabViewModel.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(RealmManager.shared.getUserDatas().first!.beginCoupleDay) / 1000).toStoryString
    }
    
    // 메인 이미지 세팅
    //
    func setMainBackgroundImage() {
        let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
        self.mainImageData = RealmManager.shared.getImageDatas().first!.mainImageData
        
        // dart 모드 체크
        // 내 프로필, 상대 프로필 사진 세팅안돼있으면 smile image set
        //
        if RealmManager.shared.getImageDatas().first!.myProfileImageData == nil {
            if isDark {
                self.myProfileImageData = UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5)
            } else {
                self.myProfileImageData = UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5)
            }
        } else {
            self.myProfileImageData = RealmManager.shared.getImageDatas().first!.myProfileImageData
        }
        if RealmManager.shared.getImageDatas().first!.partnerProfileImageData == nil {
            if isDark {
                self.partnerProfileImageData = UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5)
            } else {
                self.partnerProfileImageData = UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5)
            }
        } else {
            self.partnerProfileImageData = RealmManager.shared.getImageDatas().first!.partnerProfileImageData
        }
    }
    
    // update 프로필 이미지
    //
    func updateProfileIcon() {
        let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
        if RealmManager.shared.getImageDatas().first!.myProfileImageData == nil {
            if isDark {
                self.myProfileImageData = UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5)
            } else {
                self.myProfileImageData = UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5)
            }
        } else {
            self.myProfileImageData = RealmManager.shared.getImageDatas().first!.myProfileImageData
        }
        if RealmManager.shared.getImageDatas().first!.partnerProfileImageData == nil {
            if isDark {
                self.partnerProfileImageData = UIImage(named: "smile_dark")?.jpegData(compressionQuality: 0.5)
            } else {
                self.partnerProfileImageData = UIImage(named: "smile_white")?.jpegData(compressionQuality: 0.5)
            }
        } else {
            self.partnerProfileImageData = RealmManager.shared.getImageDatas().first!.partnerProfileImageData
        }
    }
    
    // update 메인 이미지
    //
    func updateMainBackgroundImage() {
        self.mainImageData = RealmManager.shared.getImageDatas().first!.mainImageData
    }
    
    // update 나의 프로필
    //
    func updateMyProfileImage() {
        self.myProfileImageData = RealmManager.shared.getImageDatas().first!.myProfileImageData
    }
    
    // update 상대 프로필
    //
    func updatePartnerProfileImage() {
        self.partnerProfileImageData = RealmManager.shared.getImageDatas().first!.partnerProfileImageData
    }
    
    // update PublicBeginCoupleDay
    //
    func updatePublicBeginCoupleDay() {
        // 현재 날짜 스트링 데이터 -> 현재 날짜 데이트 데이터
        // 현재 - 사귄날짜 = days
        //
        let nowDayDataString = Date().toString
        let nowDayDataDate: Date = nowDayDataString.toDate
        let minus = Int(nowDayDataDate.millisecondsSince1970)-RealmManager.shared.getUserDatas().first!.beginCoupleDay
        self.beginCoupleDay = String(describing: minus / 86400000)
        CoupleTabViewModel.publicBeginCoupleDay = String(describing: minus / 86400000)
    }
    
    // update PublicBeginCoupleFormatterDay
    //
    func updatePublicBeginCoupleFormatterDay() {
        self.beginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(RealmManager.shared.getUserDatas().first!.beginCoupleDay) / 1000).toStoryString
        CoupleTabViewModel.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(RealmManager.shared.getUserDatas().first!.beginCoupleDay) / 1000).toStoryString
    }
}
