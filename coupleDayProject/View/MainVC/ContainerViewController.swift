import UIKit

class ContainerViewController: UIViewController {
    
    private let containerViewModel = ContainerViewModel()
    
    // MARK: UI
    //
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private let setBtn: UIImageView = { // 설정 버튼
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "gearshape")
        imageView.tintColor = TrendingConstants.appMainColor
        imageView.contentMode = .center
        return imageView
    }()
    private lazy var stackView: UIStackView = { // appNameLabel + 설정 버튼
        let stackView = UIStackView(arrangedSubviews: [appNameLabel, setBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: init
    //
    override func viewWillAppear(_ animated: Bool) {
        // 상단 NavigationBar 공간 hide -> 안해주면 NavigationBar 크기만큼 자리먹음
        //
        self.navigationController?.isNavigationBarHidden = true
        
        // 성훈 업데이트 버전 테스트
        //
        let marketingVersion = "1.0.5"
        let currentProjectVersion = "1.0.0"
        let splitMarketingVersion = marketingVersion.split(separator: ".").map {$0}
        let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map {$0}
        
        // if : 가장 앞자리가 다르면 -> 업데이트 필요
        // 메시지 창 인스턴스 생성, 컨트롤러에 들어갈 버튼 액션 객체 생성 -> 클릭하면 앱스토어로 이동
        // else : 두번째 자리가 달라도 업데이트 필요
        //
        if splitCurrentProjectVersion[0] < splitMarketingVersion[0] {
            let alert = UIAlertController(title: "업데이트 알림", message: "ㅁㅁ의 새로운 버전이 있습니다. \(splitMarketingVersion) 버전으로 업데이트 해주세요.", preferredStyle: UIAlertController.Style.alert)
            let destructiveAction = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default){(_) in
                print("update alert if")
                //                System().openAppStore(urlStr: System.appStoreOpenUrlString)
            }
            alert.addAction(destructiveAction)
            self.present(alert, animated: false)
        } else {
            if  splitCurrentProjectVersion[1] < splitMarketingVersion[1] {
                let alert = UIAlertController(title: "업데이트 알림", message: "ㅁㅁ의 새로운 버전이 있습니다. \(marketingVersion) 버전으로 업데이트 해주세요.", preferredStyle: UIAlertController.Style.alert)
                let destructiveAction = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default){(_) in
                    print("update alert else if")
                    //                    System().openAppStore(urlStr: System.appStoreOpenUrlString)
                }
                alert.addAction(destructiveAction)
                self.present(alert, animated: false)
            } else {
                // 그 이외에는 업데이트 필요 없음
            }
        }
    }
    override func viewDidLoad() {
        setupView()
        
        // containerViewModel 바인딩 (연결)
        // 레이어 상태 변경 시 애니메이션 -> 너랑나랑이랑 days 왔다 갔다 하는 애니메이션
        //
        containerViewModel.onUpdatedLabel = {
            DispatchQueue.main.async {
                let transition = CATransition()
                transition.duration = 1
                transition.timingFunction = .init(name: .easeIn)
                transition.type = .fade
                self.appNameLabel.layer.add(transition, forKey: CATransitionType.fade.rawValue)
                self.appNameLabel.text = self.containerViewModel.appNameLabelValue
            }
        }
    }
    
    // MARK: func
    //
    fileprivate func setupView() {
        
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(stackView)
        
        // 설정 버튼 클릭 제스쳐
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setBtnTap(_:)))
        setBtn.isUserInteractionEnabled = true
        setBtn.addGestureRecognizer(tapGesture)
        
        // set autolayout
        //
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
        
        // add child tabman
        //
        let mainTabManVC = TabManViewController()
        addChild(mainTabManVC)
        view.addSubview(mainTabManVC.view)
        mainTabManVC.didMove(toParent: self)
        mainTabManVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTabManVC.view.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            mainTabManVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainTabManVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTabManVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    // MARK: objc
    //
    @objc
    func setBtnTap(_ gesture: UITapGestureRecognizer) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}
