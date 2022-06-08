//
//  MainContainerViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/29.
//

import UIKit

class MainContainerViewController: UIViewController {
    
    private var labelState = false // 앱 이름 <> 연애 날짜 상태확인해주는 변수
    private var changeLabelCheck = false // 타이머 시작은 딱 한번만 해야함 -> 체크하는 변수
    private var changeLabelTimer = Timer() // 자동으로 함수 실행하기 위한 타이머
    
    // MARK: UI
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "성훈커플앱"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var setBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "text.alignright"), for: .normal)
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appNameLabel, setBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.setCustomSpacing(30, after: setBtn)
        stackView.backgroundColor = .red
        return stackView
    }()
    
    // MARK: @objc
    @objc
    fileprivate func setBtnTap() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    
    }
    
    @objc // 라벨: 앱 이름 <> 연애 날짜 변경
    fileprivate func updateLabel() {
        let transition = CATransition() // 레이어 상태 변경 시 애니메이션 제공
        transition.duration = 1 // 애니메이션 길이
        transition.timingFunction = .init(name: .easeIn) // 애니메이션 곡선
        transition.type = .fade // 효과
        appNameLabel.layer.add(transition, forKey: CATransitionType.fade.rawValue) // 추가
        appNameLabel.text = labelState ? CoupleTabViewController.publicBeginCoupleDay : "성훈커플앱"
        labelState.toggle()
    }
    
    // MARK: func
    fileprivate func layoutTabMan() {
        let mainTabManVC = MainTabManViewController()
        addChild(mainTabManVC)
        view.addSubview(mainTabManVC.view)
        mainTabManVC.didMove(toParent: self)
        mainTabManVC.view.translatesAutoresizingMaskIntoConstraints = false
        mainTabManVC.view.topAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
        mainTabManVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mainTabManVC.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mainTabManVC.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    fileprivate func changeAppNameLabel() {
        if !changeLabelCheck {
            // 5초마다 updateLabel() 실행
            changeLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self,
                selector: #selector(updateLabel), userInfo: nil, repeats: true)
            changeLabelCheck = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green // set background color
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
        layoutTabMan() // set tabMan
        changeAppNameLabel()
    }
}

#if DEBUG
import SwiftUI
struct MainContainerViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    // make UI
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        MainContainerViewController()
    }
}

struct MainContainerViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainContainerViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
