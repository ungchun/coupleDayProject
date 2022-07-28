import Foundation
import UIKit
import Lottie
import Firebase
import FirebaseAuth

// 앱 시작할 때 보이는 로딩 뷰
//
class LoadingViewController: UIViewController {
    
    var window: UIWindow?
    
    // MARK: UI
    //
    private let animationView: AnimationView = { // lottie animationView
        let lottieView = AnimationView(name: "lottieFile")
        lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return lottieView
    }()
    private let loadingCenterLabel: UILabel = { // 로딩 가운데 띄우는 타이틀 라벨
        let label = UILabel()
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllLight", size: 50)
        label.textColor = .white
        return label
    }()
    private let stackView: UIStackView = { // 너랑나랑 + lottie
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: func
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TrendingConstants.appMainColorAlaph40
        
        // 너랑나랑 중에서 너, 나 textColor 변경
        //
        let attributedStr = NSMutableAttributedString(string: loadingCenterLabel.text!)
        attributedStr.addAttribute(.foregroundColor, value: TrendingConstants.appMainColor, range: (loadingCenterLabel.text! as NSString).range(of:"너"))
        attributedStr.addAttribute(.foregroundColor, value: TrendingConstants.appMainColor, range: (loadingCenterLabel.text! as NSString).range(of:"나"))
        loadingCenterLabel.attributedText = attributedStr
        
        // 애니메이션 2.5 반복
        //
        animationView.loopMode = .repeat(2.5)
        
        // 너랑나랑 + lottie stackView set
        stackView.addArrangedSubview(loadingCenterLabel)
        stackView.addArrangedSubview(animationView)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 1.5),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // lottie 애니메이션
        //
        animationView.play {(finish) in
            // 업데이트 로직
            //
            let marketingVersion = System().latestVersion()!
            let currentProjectVersion = System.appVersion!
            let splitMarketingVersion = marketingVersion.split(separator: ".").map {$0}
            let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map {$0}
            
            // if : 가장 앞자리가 다르면 -> 업데이트 필요
            // 메시지 창 인스턴스 생성, 컨트롤러에 들어갈 버튼 액션 객체 생성 -> 클릭하면 앱스토어로 이동
            // else : 두번째 자리가 달라도 업데이트 필요
            //
            if splitCurrentProjectVersion[0] < splitMarketingVersion[0] {
                let alert = UIAlertController(title: "업데이트 알림", message: "너랑나랑의 새로운 버전이 있습니다. \(marketingVersion) 버전으로 업데이트 해주세요.", preferredStyle: UIAlertController.Style.alert)
                let destructiveAction = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default){(_) in
                    System().openAppStore()
                }
                alert.addAction(destructiveAction)
                self.present(alert, animated: false)
            } else {
                if  splitCurrentProjectVersion[1] < splitMarketingVersion[1] {
                    let alert = UIAlertController(title: "업데이트 알림", message: "너랑나랑의 새로운 버전이 있습니다. \(marketingVersion) 버전으로 업데이트 해주세요.", preferredStyle: UIAlertController.Style.alert)
                    let destructiveAction = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default){(_) in
                        System().openAppStore()
                    }
                    alert.addAction(destructiveAction)
                    self.present(alert, animated: false)
                } else {
                    // 그 이외에는 업데이트 필요 없음
                    // Firebase 익명 로그인
                    //
                    Auth.auth().signInAnonymously { (authResult, error) in
                        guard let user = authResult?.user else { return }
                        let isAnonymous = user.isAnonymous
                        let uid = user.uid
                        print("isAnonymous \(isAnonymous)")
                        print("uid \(uid)")
                    }
                    
                    // realm 비어있으면 처음 세팅하는 곳으로 이동
                    // realm 안비어있으면 메인으로 이동
                    //
                    if RealmManager.shared.getUserDatas().isEmpty {
                        let rootViewcontroller = UINavigationController(rootViewController: BeginViewController())
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = rootViewcontroller
                        self.window?.makeKeyAndVisible()
                        rootViewcontroller.modalTransitionStyle = .crossDissolve
                        rootViewcontroller.modalPresentationStyle = .fullScreen
                        self.present(rootViewcontroller, animated: true, completion: nil)
                    } else {
                        let rootViewcontroller = UINavigationController(rootViewController: ContainerViewController())
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = rootViewcontroller
                        self.window?.makeKeyAndVisible()
                        rootViewcontroller.modalTransitionStyle = .crossDissolve
                        rootViewcontroller.modalPresentationStyle = .fullScreen
                        self.present(rootViewcontroller, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
