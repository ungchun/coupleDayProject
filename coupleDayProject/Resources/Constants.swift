import Foundation
import UIKit
import Photos
import RealmSwift
import WidgetKit
import GoogleMobileAds

struct CommonSize {
    
    // 아이폰 se 667 -> 16, 100
    // 아이폰 mini 812 -> 18, 120
    // 아이폰 13 pro 844 -> 18, 120
    // 아이폰 11 896 -> 20, 130
    // 아이폰 13 pro max 926 -> 22, 140
    
    static let coupleTextBigSize = UIScreen.main.bounds.size.height > 900 ? 22.0 : UIScreen.main.bounds.size.height > 850 ? 20.0 : UIScreen.main.bounds.size.height > 800 ? 18.0 : 16.0
    static let coupleProfileSize = UIScreen.main.bounds.size.height > 850 ? 75.0 : 70.0
    static let coupleStackViewHeightSize = UIScreen.main.bounds.size.height > 850 ? UIScreen.main.bounds.size.height / 8 : UIScreen.main.bounds.size.height / 10
    
    static let coupleCellTextBigSize = UIScreen.main.bounds.size.height > 850 ? 17.0 : UIScreen.main.bounds.size.height > 800 ? 15.0 : 14.0
    static let coupleCellTextSmallSize = UIScreen.main.bounds.size.height > 850 ? 13.0 : UIScreen.main.bounds.size.height > 800 ? 12.0 : 11.0
    static let coupleCellImageSize = UIScreen.main.bounds.size.height > 900 ? 140.0 : UIScreen.main.bounds.size.height > 850 ? 130.0 : UIScreen.main.bounds.size.height > 800 ? 120.0 : 100.0
}

// MARK: RealmManager Singleton
//
struct RealmManager {
    // realm db 삭제
    //     try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
    
    // Singleton object
    //
    static let shared: RealmManager = .init()
    
    // Realm instance
    // realm db 삭제없이 model 변경하고싶으면 schemaVersion 변경 하면 됨. 대신 전 버전보다는 커야함
    //
    private var realm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ungchun.coupleDayProject")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        do {
            return try Realm(configuration: config)
        } catch let error as NSError {
            print(error.debugDescription)
            fatalError("Can't continue further, no Realm available")
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
            if RealmManager.shared.getUserDatas().first!.zeroDayStartCheck {
                RealmManager.shared.getUserDatas().first!.beginCoupleDay = Int(datePicker.date.toString.toDate.millisecondsSince1970)
            } else {
                RealmManager.shared.getUserDatas().first!.beginCoupleDay = Int(Calendar.current.date(byAdding: .day, value: -1, to: datePicker.date.toString.toDate)!.millisecondsSince1970)
            }
            
        })
        WidgetCenter.shared.reloadAllTimelines() // 위젯 새로고침
    }
    
    // realm NSData 속성은 16MB를 초과할 수 없다 -> 16777216 을 1024 로 2번 나누면 16MB 가 되는데 그냥 16000000 으로 맞춰서 예외처리, 16000000 보다 작으면 0.5 퀄리티 16000000 크면 0.25 퀄리티, pngData로 하면 위험부담이 생겨서 배제 -> 13777014 이 사이즈도 막힘.. 인터넷에서는 16Mb라고 하는데 그냥 10000000로 맞춤
    //
    func updateMainImage(mainImage: UIImage) {
        try? realm.write({
            RealmManager.shared.getImageDatas().first!.homeMainImage = (mainImage.pngData()?.count)! > 10000000 ? mainImage.jpegData(compressionQuality: 0.25) : mainImage.jpegData(compressionQuality: 0.5)
        })
        WidgetCenter.shared.reloadAllTimelines() // 위젯 새로고침
    }
    func updateMyProfileImage(myProfileImage: UIImage) {
        try? realm.write({
            RealmManager.shared.getImageDatas().first!.myProfileImage = (myProfileImage.pngData()?.count)! > 16000000 ? myProfileImage.jpegData(compressionQuality: 0.25) : myProfileImage.jpegData(compressionQuality: 0.5)
        })
    }
    func updatePartnerProfileImage(partnerProfileImage: UIImage) {
        try? realm.write({
            RealmManager.shared.getImageDatas().first!.partnerProfileImage = (partnerProfileImage.pngData()?.count)! > 16000000 ? partnerProfileImage.jpegData(compressionQuality: 0.25) : partnerProfileImage.jpegData(compressionQuality: 0.5)
        })
    }
}


// MARK: app version 확인, 앱 업데이트 관련
//
struct System {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String // 현재 버전 정보 : 타겟 -> 일반 -> Version
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String // 개발자가 내부적으로 확인하기 위한 용도 : 타겟 -> 일반 -> Build
    
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/1635302922" // 1635302922 -> Apple ID
    
    // 앱 스토어 최신 정보 확인
    //
    func latestVersion() -> String? {
        let appleID = 1635302922
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
    //
    func openAppStore() {
        guard let url = URL(string: System.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: app main color
//
struct TrendingConstants {
    static let appMainColor = UIColor(red: 243/255, green: 129/255, blue: 129/255, alpha: 1)
    static let appMainColorAlaph40 = UIColor(red: 234/255, green: 188/255, blue: 188/255, alpha: 1)
}

// MARK: return year string
//
struct DateValues {
    // 올해 year -> yyyy 형태로 return
    //
    static func GetOnlyYear() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        return yearString
    }
    
    // 내년 year -> yyyy 형태로 return
    //
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
//
struct LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .medium)
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
//
struct ImagePicker {
    // https://eeyatho.tistory.com/141 -> iOS 11 부터, UIImagePickerController 라이브러리 권한 필요없음..
    //
    static func photoAuthCheck(imagePickerController: UIImagePickerController) -> Int{
        let status = PHPhotoLibrary.authorizationStatus().rawValue
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
//
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
