import UIKit

import Firebase
import FirebaseAuth
import Lottie

final class LoadingViewController: BaseViewController {
	
	//MARK: - Properties
	
	var coordinator: AppCoordinator!
	private var window: UIWindow?
	
	//MARK: - Views
	
	private let loadingView = LoadingView()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		animationPlay()
	}
	
	override func setLayout() {
		view.addSubview(loadingView)
		
		NSLayoutConstraint.activate([
			loadingView.heightAnchor.constraint(
				equalToConstant: UIScreen.main.bounds.size.height / 1.5
			),
			loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
	
	override func setupView() {
		view.backgroundColor = TrendingConstants.appMainColorAlaph40
	}
}

private extension LoadingViewController {
	
	//MARK: - Functions
	
	func animationPlay() {
		loadingView.lottieAnimationView.play { [weak self] (finish) in
			let marketingVersion = System().latestVersion()!
			let currentProjectVersion = System.appVersion!
			let splitMarketingVersion = marketingVersion.split(separator: ".").map {$0}
			let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map {$0}
			if splitCurrentProjectVersion[0] < splitMarketingVersion[0] { // 가장 앞자리가 다르면 -> 업데이트 필요
				self?.needUpdateVersion(marketingVersion)
			} else {
				if  splitCurrentProjectVersion[1] < splitMarketingVersion[1] { // 두번째 자리가 달라도 업데이트 필요
					self?.needUpdateVersion(marketingVersion)
				} else { // 그 이외에는 업데이트 필요 없음
					Auth.auth().signInAnonymously { (authResult, error) in }
					if RealmService.shared.getUserDatas().isEmpty {
						self?.coordinator!.showSetBeginDayView()
					} else {
						self?.coordinator!.showMainView()
					}
				}
			}
		}
	}
	
	func needUpdateVersion(_ marketingVersion: String) {
		let alert = UIAlertController(
			title: "업데이트 알림",
			message: "너랑나랑의 새로운 버전이 있습니다. \(marketingVersion) 버전으로 업데이트 해주세요.",
			preferredStyle: .alert
		)
		let destructiveAction = UIAlertAction(
			title: "업데이트",
			style: .default
		){(_) in System().openAppStore()}
		alert.addAction(destructiveAction)
		self.present(alert, animated: false)
	}
}
