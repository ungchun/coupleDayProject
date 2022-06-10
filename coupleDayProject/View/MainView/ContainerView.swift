//
//  ContainerView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/09.
//

import UIKit

// 초반에 디자인했지만 안씀
class ContainerView: UIView {
 
    var setBtnAction: (() -> Void)? // setBtnAction
    
    private var labelState = false // 앱 이름 <> 연애 날짜 상태확인해주는 변수
    private var changeLabelCheck = false // 타이머 시작은 딱 한번만 해야함 -> 체크하는 변수
    private var changeLabelTimer = Timer() // 자동으로 함수 실행하기 위한 타이머
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "성훈커플앱"
        label.font = .systemFont(ofSize: 20)
        print("label \(label.frame.height)")
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
        stackView.setCustomSpacing(30, after: setBtn)
        stackView.backgroundColor = .red
        return stackView
    }()
    
//    lazy var testView: UIView = {
//        
//    }

    // MARK: func
    fileprivate func setup() {
        addSubview(appNameLabel)
        addSubview(setBtn)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
        changeAppNameLabel()
    }
    
    fileprivate func changeAppNameLabel() {
        if !changeLabelCheck {
            // 5초마다 updateLabel() 실행
            changeLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self,
                selector: #selector(updateLabel), userInfo: nil, repeats: true)
            changeLabelCheck = true
        }
    }
    
    // MARK: objc
    @objc
    func setBtnTap() {
        setBtnAction!()
    }
    
    @objc // 라벨: 앱 이름 <> 연애 날짜 변경
    fileprivate func updateLabel() {
        let transition = CATransition() // 레이어 상태 변경 시 애니메이션 제공
        transition.duration = 1 // 애니메이션 길이
        transition.timingFunction = .init(name: .easeIn) // 애니메이션 곡선
        transition.type = .fade // 효과
        appNameLabel.layer.add(transition, forKey: CATransitionType.fade.rawValue) // 추가
        appNameLabel.text = labelState ? "\(CoupleTabViewController.publicBeginCoupleDay) days" : "성훈커플앱"
        labelState.toggle()
    }
}
