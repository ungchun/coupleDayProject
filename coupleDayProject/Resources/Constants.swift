//
//  Constant.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/06.
//

import Foundation
import UIKit
import Photos
import RealmSwift
import WidgetKit

//enum AppstoreOpenError: Error {
//    case invalidAppStoreURL
//    case cantOpenAppStoreURL
//}


class RealmManager {
    // realm db 삭제
    //     try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!) // remove realm db
    
    // Singleton object
    static let shared: RealmManager = .init()
    
    // Realm instance
    private var realm: Realm {
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" )
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ungchun.coupleDayProject")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1) // realm db 삭제없이 model 변경하고싶으면 schemaVersion 변경 하면 됨. 대신 전 버전보다는 커야함
        return try! Realm(configuration: config)
    }
    
    func getUserDatas() -> [User] {
        Array(realm.objects(User.self))
    }
    func getImageDatas() -> [ImageModel] {
        Array(realm.objects(ImageModel.self))
    }
    func writeUserData(userData: User) {
        try? realm.write({
            realm.add(userData)
        })
    }
    func writeImageData(imageData: ImageModel) {
        try? realm.write({
            realm.add(imageData)
        })
    }
    func updateBeginCoupleDay(datePicker: UIDatePicker) {
        try? realm.write({
            if RealmManager.shared.getUserDatas().first!.zeroDayStart {
                RealmManager.shared.getUserDatas().first!.beginCoupleDay = Int(datePicker.date.toString.toDate.millisecondsSince1970)
            } else {
                RealmManager.shared.getUserDatas().first!.beginCoupleDay = Int(Calendar.current.date(byAdding: .day, value: -1, to: datePicker.date.toString.toDate)!.millisecondsSince1970)
            }
            
        })
        WidgetCenter.shared.reloadAllTimelines() // 위젯 새로고침
    }
    // realm NSData 속성은 16MB를 초과할 수 없다 -> 16777216 을 1024 로 2번 나누면 16MB 가 되는데 그냥 16000000 으로 맞춰서 예외처리, 16000000 보다 작으면 0.5 퀄리티 16000000 크면 0.25 퀄리티, pngData로 하면 위험부담이 생겨서 배제
    func updateMainImage(mainImage: UIImage) {
        try? realm.write({
            RealmManager.shared.getImageDatas().first!.mainImageData = (mainImage.pngData()?.count)! > 16000000 ? mainImage.jpegData(compressionQuality: 0.25) : mainImage.jpegData(compressionQuality: 0.5)
        })
        WidgetCenter.shared.reloadAllTimelines() // 위젯 새로고침
    }
    func updateMyProfileImage(myProfileImage: UIImage) {
        try? realm.write({
            RealmManager.shared.getImageDatas().first!.myProfileImageData = (myProfileImage.pngData()?.count)! > 16000000 ? myProfileImage.jpegData(compressionQuality: 0.25) : myProfileImage.jpegData(compressionQuality: 0.5)
        })
    }
    func updatePartnerProfileImage(partnerProfileImage: UIImage) {
        try? realm.write({
            RealmManager.shared.getImageDatas().first!.myProfileImageData = (partnerProfileImage.pngData()?.count)! > 16000000 ? partnerProfileImage.jpegData(compressionQuality: 0.25) : partnerProfileImage.jpegData(compressionQuality: 0.5)
        })
    }
}


// MARK: app version 확인, 앱 업데이트 관련
struct System {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String // 현재 버전 정보 : 타겟 -> 일반 -> Version
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String // 개발자가 내부적으로 확인하기 위한 용도 : 타겟 -> 일반 -> Build
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String // bundleIdentifier
    
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/1548711244" // 1548711244 -> Apple ID
    
    // 앱 스토어 최신 정보 확인
    func latestVersion() -> String? {
        let appleID = "이곳에 Apple ID"
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)&country=kr"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
    
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: app main color
struct TrendingConstants {
    static let appMainColor = UIColor(red: 243/255, green: 129/255, blue: 129/255, alpha: 1)
    static let appMainColorAlaph40 = UIColor(red: 234/255, green: 188/255, blue: 188/255, alpha: 1)
}

// MARK: return year string
class DateValues {
    // 올해 year -> yyyy 형태로 return
    static func GetOnlyYear() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        return yearString
    }
    // 내년 year -> yyyy 형태로 return
    static func GetOnlyNextYear() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        let nextYearString = String(describing: Int(yearString)!+1)
        return nextYearString
    }
}

// MARK: Loading
class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .medium)
                // 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.frame
                window.addSubview(loadingIndicatorView)
            }
            loadingIndicatorView.startAnimating()
        }
    }
    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}

// MARK: ImagePicker
class ImagePicker {
    // https://eeyatho.tistory.com/141 -> iOS 11 부터, UIImagePickerController 라이브러리 권한 필요없음..
    static func photoAuthCheck(imagePickerController: UIImagePickerController) -> Int{
        let status = PHPhotoLibrary.authorizationStatus().rawValue
        print("status \(status)")
        switch status {
        case 0:
            // .notDetermined - 사용자가 아직 권한에 대한 설정을 하지 않았을 때
            print("CALLBACK FAILED: is .notDetermined")
            imagePickerController.sourceType = .photoLibrary
            return 0
        case 1:
            // .restricted - 시스템에 의해 앨범에 접근 불가능하고, 권한 변경이 불가능한 상태
            print("CALLBACK FAILED: is .restricted")
            return 1
        case 2:
            // .denied - 접근이 거부된 경우
            print("CALLBACK FAILED: is .denied")
            let alert = UIAlertController(title: "권한요청", message: "권한이 필요합니다. 권한 설정 화면으로 이동합니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                if (UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)){
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            })
            alert.addAction(okAction)
            return 2
        case 3:
            // .authorized - 권한 허용된 상태
            print("CALLBACK SUCCESS: is .authorized")
            imagePickerController.sourceType = .photoLibrary
            return 3
        case 4:
            // .limited (iOS 14 이상 사진 라이브러리 전용) - 갤러리의 접근이 선택한 사진만 허용된 경우
            print("CALLBACK SUCCESS: is .limited")
            return 4
        default:
            // 그 외의 경우 - 미래에 새로운 권한 추가에 대비
            print("CALLBACK FAILED: is unknwon state.")
            return 5
        }
    }
}

// MARK: SwiftUI 프리뷰
//#if DEBUG
//import SwiftUI
//struct DemoRepresentable: UIViewControllerRepresentable {
//    // update
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//    }
//    // make UI
//    @available(iOS 13.0, *)
//    func makeUIViewController(context: Context) -> some UIViewController {
//        ControllerName()
//    }
//}
//
//struct DemoController_Previews: PreviewProvider {
//    static var previews: some View {
//        DemoRepresentable()
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//#endif
