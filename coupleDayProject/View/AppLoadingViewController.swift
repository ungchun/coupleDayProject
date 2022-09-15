import Foundation
import UIKit
import Lottie
import Firebase
import FirebaseAuth

final class AppLoadingViewController: UIViewController {
    
    // MARK: Properties
    //
    var coordinator: AppCoordinator!
    private var window: UIWindow?
    
    // MARK: Views
    //
    private let lottieAnimationView: AnimationView = {
        let lottieView = AnimationView(name: "lottieFile")
        lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return lottieView
    }()
    private let loadingCenterLabel: UILabel = {
        let label = UILabel()
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllLight", size: 50)
        label.textColor = .white
        return label
    }()
    private let loadingContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        lottieAnimationView.play { [weak self] (finish) in
            guard let self = self else { return }
            
            let marketingVersion = System().latestVersion()!
            let currentProjectVersion = System.appVersion!
            let splitMarketingVersion = marketingVersion.split(separator: ".").map {$0}
            let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map {$0}
            
            if splitCurrentProjectVersion[0] < splitMarketingVersion[0] { // 가장 앞자리가 다르면 -> 업데이트 필요
                self.needUpdateVersion(marketingVersion)
            } else {
                if  splitCurrentProjectVersion[1] < splitMarketingVersion[1] { // 두번째 자리가 달라도 업데이트 필요
                    self.needUpdateVersion(marketingVersion)
                } else { // 그 이외에는 업데이트 필요 없음
                    Auth.auth().signInAnonymously { (authResult, error) in }
                    if RealmManager.shared.getUserDatas().isEmpty {
                        self.coordinator!.showSetBeginDayView()
                    } else {
                        self.coordinator!.showMainView()
                    }
                }
            }
        }
    }
    
    // MARK: Functions
    //
    private func setUpView() {
        self.view.backgroundColor = TrendingConstants.appMainColorAlaph40
        
        // 너랑나랑 중에서 너, 나 textColor 변경
        //
        guard let loadingCenterLabelText = loadingCenterLabel.text else { return }
        let attributedStr = NSMutableAttributedString(string: loadingCenterLabelText)
        attributedStr.addAttribute(.foregroundColor, value: TrendingConstants.appMainColor, range: (loadingCenterLabelText as NSString).range(of:"너"))
        attributedStr.addAttribute(.foregroundColor, value: TrendingConstants.appMainColor, range: (loadingCenterLabelText as NSString).range(of:"나"))
        loadingCenterLabel.attributedText = attributedStr
        
        lottieAnimationView.loopMode = .repeat(2.5)
        
        loadingContentStackView.addArrangedSubview(loadingCenterLabel)
        loadingContentStackView.addArrangedSubview(lottieAnimationView)
        view.addSubview(loadingContentStackView)
        NSLayoutConstraint.activate([
            loadingContentStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 1.5),
            loadingContentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingContentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    private func needUpdateVersion(_ marketingVersion: String) {
        let alert = UIAlertController(title: "업데이트 알림", message: "너랑나랑의 새로운 버전이 있습니다. \(marketingVersion) 버전으로 업데이트 해주세요.", preferredStyle: UIAlertController.Style.alert)
        let destructiveAction = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default){(_) in
            System().openAppStore()
        }
        alert.addAction(destructiveAction)
        self.present(alert, animated: false)
    }
}
