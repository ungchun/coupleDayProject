import Photos
import UIKit
import WidgetKit

import GoogleMobileAds
import Kingfisher
import RealmSwift

struct CommonSize {
	
	// 아이폰 se 667 -> 16, 100
	// 아이폰 mini 812 -> 18, 120
	// 아이폰 13 pro 844 -> 18, 120
	// 아이폰 11 896 -> 20, 130
	// 아이폰 13 pro max 926 -> 22, 140
	
	static let coupleTextBigSize = UIScreen.main.bounds.size.height > 900
	? 22.0 : UIScreen.main.bounds.size.height > 850
	? 20.0 : UIScreen.main.bounds.size.height > 800
	? 18.0 : 16.0
	static let coupleProfileSize = UIScreen.main.bounds.size.height > 850 ? 75.0 : 70.0
	static let coupleStackViewHeightSize = UIScreen.main.bounds.size.height > 850
	? UIScreen.main.bounds.size.height / 8 : UIScreen.main.bounds.size.height / 10
	
	static let coupleCellTextBigSize = UIScreen.main.bounds.size.height > 850
	? 17.0 : UIScreen.main.bounds.size.height > 800
	? 15.0 : 14.0
	static let coupleCellTextSmallSize = UIScreen.main.bounds.size.height > 850
	? 13.0 : UIScreen.main.bounds.size.height > 800
	? 12.0 : 11.0
	static let coupleCellImageSize = UIScreen.main.bounds.size.height > 900
	? 140.0 : UIScreen.main.bounds.size.height > 850
	? 130.0 : UIScreen.main.bounds.size.height > 800
	? 120.0 : 100.0
}

// UIImage 객체의 사진용량 줄이기

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
	let scale = newWidth / image.size.width
	let newHeight = image.size.height * scale
	UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
	image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
	let newImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return newImage!
}

// app version 확인, 앱 업데이트 관련

struct System {
	/// 현재 버전 정보 : 타겟 -> 일반 -> Version
	static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	
	/// 개발자가 내부적으로 확인하기 위한 용도 : 타겟 -> 일반 -> Build
	static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
	
	/// 1635302922 -> Apple ID
	static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/1635302922"
	
	/// 앱 스토어 최신 정보 확인
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
	
	/// 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
	func openAppStore() {
		guard let url = URL(string: System.appStoreOpenUrlString) else { return }
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
}

// app main color

struct TrendingConstants {
	static let appMainColor = UIColor(red: 243/255, green: 129/255, blue: 129/255, alpha: 1)
	static let appMainColorAlaph40 = UIColor(red: 234/255, green: 188/255, blue: 188/255, alpha: 1)
}

// return year string

struct DateValues {
	/// 올해 year -> return yyyy
	static func GetOnlyYear() -> String {
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		let yearString = dateFormatter.string(from: date)
		return yearString
	}
	
	/// 내년 year -> return yyyy
	static func GetOnlyNextYear() -> String {
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		let yearString = dateFormatter.string(from: date)
		let nextYearString = String(describing: Int(yearString)!+1)
		return nextYearString
	}
}

struct CacheImageManger {
	func downloadImageAndCache(urlString: String) {
		guard let url = URL(string: urlString) else { return }
		ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
			switch result {
			case .success(let value):
				if value.image != nil { //캐시가 존재하는 경우
				} else { //캐시가 존재하지 않는 경우
					let resource = ImageResource(downloadURL: url)
					KingfisherManager.shared.retrieveImage(
						with: resource,
						options: nil,
						progressBlock: nil
					) { result in
						switch result {
						case .success(let value):
							print("success value.image \(value.image)")
						case .failure(let error):
							print("Error: \(error)")
						}
					}
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}

// Loading

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

// ImagePicker

struct ImagePicker {
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
			let alert = UIAlertController(
				title: "권한요청",
				message: "권한이 필요합니다. 권한 설정 화면으로 이동합니다.",
				preferredStyle: .alert
			)
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

// ViewModel DataBinding Observable

final class Observable<T> {
	private var listener: ((T) -> Void)?
	
	var value: T {
		didSet {
			listener?(value)
		}
	}
	
	init(_ value: T) {
		self.value = value
	}
	
	func bind(_ closure: @escaping (T) -> Void) {
		closure(value)
		listener = closure
	}
}

/// 기념일 present 할 때 위에 어느정도 띄워주는 custom modal
final class PresentationController: UIPresentationController {
	
	let blurEffectView: UIVisualEffectView!
	var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
	
	override init(
		presentedViewController: UIViewController,
		presenting presentingViewController: UIViewController?
	) {
		let blurEffect = UIBlurEffect(style: .dark)
		blurEffectView = UIVisualEffectView(effect: blurEffect)
		super.init(
			presentedViewController: presentedViewController,
			presenting: presentingViewController
		)
		tapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(dismissController)
		)
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.blurEffectView.isUserInteractionEnabled = true
		self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	override var frameOfPresentedViewInContainerView: CGRect {
		CGRect(
			origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.15),
			size: CGSize(
				width: self.containerView!.frame.width,
				height: self.containerView!.frame.height * 0.85
			)
		)
	}
	
	override func presentationTransitionWillBegin() {
		self.blurEffectView.alpha = 0
		self.containerView?.addSubview(blurEffectView)
		self.presentedViewController.transitionCoordinator?.animate(
			alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
				self.blurEffectView.alpha = 0.7
			}, completion: { (UIViewControllerTransitionCoordinatorContext) in }
		)
	}
	
	override func dismissalTransitionWillBegin() {
		self.presentedViewController.transitionCoordinator?.animate(
			alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
				self.blurEffectView.alpha = 0
			}, completion: { (UIViewControllerTransitionCoordinatorContext) in
				self.blurEffectView.removeFromSuperview()
			}
		)
	}
	
	override func containerViewWillLayoutSubviews() {
		super.containerViewWillLayoutSubviews()
		presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
	}
	
	override func containerViewDidLayoutSubviews() {
		super.containerViewDidLayoutSubviews()
		presentedView?.frame = frameOfPresentedViewInContainerView
		blurEffectView.frame = containerView!.bounds
	}
	
	@objc func dismissController(){
		self.presentedViewController.dismiss(animated: true, completion: nil)
	}
}
