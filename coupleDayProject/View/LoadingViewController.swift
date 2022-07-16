import Foundation
import UIKit
import Lottie

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
