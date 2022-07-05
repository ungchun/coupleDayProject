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
//    let coupleTabViewModel = CoupleTabViewModel()
    
    // MARK: UI
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "app name"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        label.textColor = .black
        return label
    }()

    private lazy var setBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "gearshape"), for: .normal)
        return btn
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
        view.backgroundColor = .white // set background color
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
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
    func setBtnTap() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    // MARK: init
    override func viewWillAppear(_ animated: Bool) {
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
