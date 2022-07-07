//
//  MainContainerViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/29.
//

import UIKit
import RealmSwift

class ContainerViewController: UIViewController {
    
    let containerViewModel = ContainerViewModel()
    
    let realm = try! Realm()
    
    // MARK: UI
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    
    lazy var setBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "gearshape")
        imageView.tintColor = TrendingConstants.appMainColor
        imageView.contentMode = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setBtnTap(_:))) // 이미지 변경 제스쳐
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appNameLabel, setBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: func
    fileprivate func setupView() {
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
        
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
    @objc
    func setBtnTap(_ gesture: UITapGestureRecognizer) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    // MARK: init
    override func viewWillAppear(_ animated: Bool) {
        let marketingVersion = "1.0.5"
        let currentProjectVersion = "1.0.0"
        let splitMarketingVersion = marketingVersion.split(separator: ".").map {$0}
        let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map {$0}
        print("splitMarketingVersionDemo \(splitMarketingVersion)")
        print("splitCurrentProjectVersionDemo \(splitCurrentProjectVersion)")
        
        // 가장 앞자리가 다르면 -> 업데이트 필요
        if splitCurrentProjectVersion[0] < splitMarketingVersion[0] {
            // 메시지창 컨트롤러 인스턴스 생성
            let alert = UIAlertController(title: "업데이트 알림", message: "ㅁㅁ의 새로운 버전이 있습니다. \(splitMarketingVersion) 버전으로 업데이트 해주세요.", preferredStyle: UIAlertController.Style.alert)
            let destructiveAction = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default){(_) in // 메시지 창 컨트롤러에 들어갈 버튼 액션 객체 생성
                // 버튼 클릭시 실행되는 코드
                print("update alert if")
                //                System().openAppStore(urlStr: System.appStoreOpenUrlString)
            }
            alert.addAction(destructiveAction) //메시지 창 컨트롤러에 버튼 액션을 추가
            self.present(alert, animated: false) //메시지 창 컨트롤러를 표시
        } else {
            if  splitCurrentProjectVersion[1] < splitMarketingVersion[1] { // 두번째 자리가 달라도 업데이트 필요
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
        
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" ) // realm url
        self.navigationController?.isNavigationBarHidden = true // 상단 NavigationBar 공간 hide
    }
    
    override func viewDidLoad() {
        
        setupView()
        
        // 바인딩
        containerViewModel.onUpdatedLabel = {
            DispatchQueue.main.async {
                let transition = CATransition() // 레이어 상태 변경 시 애니메이션 제공
                transition.duration = 1 // 애니메이션 길이
                transition.timingFunction = .init(name: .easeIn) // 애니메이션 곡선
                transition.type = .fade // 효과
                self.appNameLabel.layer.add(transition, forKey: CATransitionType.fade.rawValue) // 추가
                self.appNameLabel.text = self.containerViewModel.appNameLabelValue
            }
        }
    }
}
