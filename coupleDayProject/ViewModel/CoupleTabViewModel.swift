//
//  CoupleTabViewModel.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/29.
//

import Foundation
import RealmSwift
import UIKit

class CoupleTabViewModel {
    
    static var publicBeginCoupleDay = ""
    static var publicBeginCoupleFormatterDay = ""
    static var changeMainImageCheck = false
    static var changeCoupleDayMainCheck = false
    static var changeCoupleDayStoryCheck = false
    
    var realm: Realm!
    
    var onMainImageDataUpdated: () -> Void = {}
    var onMyProfileImageDataUpdated: () -> Void = {}
    var onPartnerProfileImageDataUpdated: () -> Void = {}
    
    var onPublicBeginCoupleFormatterDayUpdated: () -> Void = {}
    var onPublicBeginCoupleDayUpdated: () -> Void = {}
    
    var mainImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5) {
        didSet {
            onMainImageDataUpdated()
        }
    }
    var myProfileImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5) {
        didSet {
            onMyProfileImageDataUpdated()
        }
    }
    var partnerProfileImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5) {
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
    
    init() {
        //        setMainBackgroundImage()
        //        setBeginCoupleDay()
    }
    
    // 날짜 세팅
    func setBeginCoupleDay() {
        realm = try? Realm()
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
        self.beginCoupleDay = String(describing: minus / 86400000)
        CoupleTabViewModel.publicBeginCoupleDay = String(describing: minus / 86400000)
        self.beginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
        CoupleTabViewModel.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
    }
    
    // 메인 이미지 세팅
    func setMainBackgroundImage() {
        realm = try? Realm()
        let realmImageData = realm.objects(Image.self)
        let mainImageData = realmImageData[0].mainImageData
        let myProfileImageData = realmImageData[0].myProfileImageData
        let partnerProfileImageData = realmImageData[0].partnerProfileImageData
        self.mainImageData = mainImageData
        self.myProfileImageData = myProfileImageData
        self.partnerProfileImageData = partnerProfileImageData
    }
    
    // update 메인 이미지
    func updateMainBackgroundImage() {
        realm = try? Realm()
        let realmImageData = realm.objects(Image.self)
        let mainImageData = realmImageData[0].mainImageData
        self.mainImageData = mainImageData
    }
    
    // update 나의 프로필
    func updateMyProfileImage() {
        realm = try? Realm()
        let realmImageData = realm.objects(Image.self)
        let myProfileImageData = realmImageData[0].myProfileImageData
        self.myProfileImageData = myProfileImageData
    }
    
    // update 상대 프로필
    func updatePartnerProfileImage() {
        realm = try? Realm()
        let realmImageData = realm.objects(Image.self)
        let partnerProfileImageData = realmImageData[0].partnerProfileImageData
        self.partnerProfileImageData = partnerProfileImageData
    }
    
    // update PublicBeginCoupleDay
    func updatePublicBeginCoupleDay() {
        print("AAAAA")
        realm = try? Realm()
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
        self.beginCoupleDay = String(describing: minus / 86400000)
        CoupleTabViewModel.publicBeginCoupleDay = String(describing: minus / 86400000)
    }
    
    // update PublicBeginCoupleFormatterDay
    func updatePublicBeginCoupleFormatterDay() {
        realm = try? Realm()
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        self.beginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
        CoupleTabViewModel.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
    }
}
