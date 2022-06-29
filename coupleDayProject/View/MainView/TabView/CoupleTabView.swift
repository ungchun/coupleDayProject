////
////  CoupleTabView.swift
////  coupleDayProject
////
////  Created by 김성훈 on 2022/06/09.
////
//
//import UIKit
//
//class CoupleTabView: UIView {
//
//    var myProfileAction: (() -> Void)?
//    var partnerProfileAction: (() -> Void)?
//
//    private var mainImageData: Data!
//    private var myProfileImageData: Data!
//    private var partnerProfileImageData: Data!
//
//    // MARK: init
//    required init(frame: CGRect, mainImageUrl: Data, myProfileImageData: Data, partnerProfileImageData: Data) {
//        super.init(frame: frame)
//        self.mainImageData = mainImageUrl
//        self.myProfileImageData = myProfileImageData
//        self.partnerProfileImageData = partnerProfileImageData
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: UI
//    private lazy var coupleTabStackView: UIStackView = { // 커플 탭 전체 뷰
//        let view = UIStackView()
//        view.axis = .vertical
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    private lazy var topTabBackView: UIView = { // 상단 탭 뒤에 뷰
//        let view = UIView()
//        view.backgroundColor = .green
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    private lazy var mainImageView: UIImageView = { // 메인 이미지 뷰
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.image = UIImage(data: self.mainImageData)
//        return view
//    }()
//    private lazy var emptyView: UIView = { // 하단 빈 공간 채우는 뷰
//        let view = UIView()
//        view.backgroundColor = .gray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    private lazy var coupleStackView: UIStackView = { // 내 프로필 + day + 상대 프로필
//        let view = UIStackView()
//        view.axis = .horizontal
//        view.alignment = .center
//        view.distribution = .equalSpacing
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    private lazy var myProfileUIImageView: UIImageView = { // 내 프로필 뷰
//        let view = UIImageView()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myProfileTap(_:))) // 이미지 변경 제스쳐
//        view.addGestureRecognizer(tapGesture)
//        view.layer.cornerRadius = 50 // 둥글게
//        view.clipsToBounds = true
//        view.isUserInteractionEnabled = true
//        view.image = UIImage(data: self.myProfileImageData)
//        return view
//    }()
//    private lazy var partnerProfileUIImageView: UIImageView = { // 상대 프로필 뷰
//        let view = UIImageView()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:))) // 이미지 변경 제스쳐
//        view.addGestureRecognizer(tapGesture)
//        view.layer.cornerRadius = 50 // 둥글게
//        view.clipsToBounds = true
//        view.isUserInteractionEnabled = true
//        view.image = UIImage(data: self.partnerProfileImageData)
//        return view
//    }()
//    private lazy var iconDayStackView: UIStackView = { // 하트 아이콘 + day
//       let view = UIStackView()
//        view.axis = .vertical
//        view.alignment = .center
//        view.spacing = 0
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    private lazy var loveIconView: UIImageView = { // 하트 아이콘
//        let view = UIImageView()
//        view.image = UIImage(systemName: "heart.fill")
//        view.tintColor = TrendingConstants.appMainColor
//        return view
//    }()
//    private lazy var mainTextLabel: UILabel = { // day
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.font = UIFont(name: "GangwonEduAllLight", size: 25)
//        label.textColor = .black
//        return label
//    }()
//
//    private lazy var testLabel_0: UILabel = {
//        var label = UILabel()
//        label.text = "다가오는 기념일"
//        return label
//    }()
//    private lazy var testLabel_1: UILabel = {
//        var label = UILabel()
//        label.text = "생일"
//        return label
//    }()
//    private lazy var testLabel_2: UILabel = {
//        var label = UILabel()
//        label.text = "D-100"
//        return label
//    }()
//    private lazy var testLabel_3: UILabel = {
//        var label = UILabel()
//        label.text = "로즈데이"
//        return label
//    }()
//    private lazy var comingStoryStackView: UIStackView = {
//        var stackView = UIStackView(arrangedSubviews: [testLabel_0, testLabel_1, testLabel_2, testLabel_3])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//        stackView.axis = .vertical
//        stackView.spacing = 10
//        return stackView
//    }()
//
//    // MARK: objc
//    @objc
//    func myProfileTap(_ gesture: UITapGestureRecognizer) { // 내 사진 변경
//        myProfileAction!()
//    }
//    @objc
//    func partnerProfileTap(_ gesture: UITapGestureRecognizer) { // 상대 사진 변경
//        partnerProfileAction!()
//    }
//
//    // MARK: func
//    fileprivate func setup() {
//        addSubview(coupleTabStackView)
//        coupleTabStackView.addArrangedSubview(topTabBackView)
//        coupleTabStackView.addArrangedSubview(mainImageView)
//        coupleTabStackView.addArrangedSubview(coupleStackView)
//        coupleTabStackView.addArrangedSubview(emptyView)
//
//        coupleStackView.addArrangedSubview(myProfileUIImageView)
//        coupleStackView.addArrangedSubview(iconDayStackView)
//        coupleStackView.addArrangedSubview(partnerProfileUIImageView)
//
//        iconDayStackView.addArrangedSubview(loveIconView)
//        iconDayStackView.addArrangedSubview(mainTextLabel)
//
//        mainTextLabel.text = "\(CoupleTabViewController.publicBeginCoupleDay)"
//
//        NSLayoutConstraint.activate([
//            myProfileUIImageView.widthAnchor.constraint(equalToConstant: 100),
//            myProfileUIImageView.heightAnchor.constraint(equalToConstant: 100),
//
//            partnerProfileUIImageView.widthAnchor.constraint(equalToConstant: 100),
//            partnerProfileUIImageView.heightAnchor.constraint(equalToConstant: 100),
//
//            loveIconView.widthAnchor.constraint(equalToConstant: 30),
//            loveIconView.heightAnchor.constraint(equalToConstant: 30),
//
//            topTabBackView.topAnchor.constraint(equalTo: self.topAnchor),
//            topTabBackView.heightAnchor.constraint(equalToConstant: 80),
//
//            mainImageView.heightAnchor.constraint(equalToConstant: 300),
//            coupleStackView.heightAnchor.constraint(equalToConstant: 100),
//
//            coupleTabStackView.topAnchor.constraint(equalTo: self.topAnchor),
//            coupleTabStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            coupleTabStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
//            coupleTabStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
//        ])
//
//    }
//
//
//
//
//
//}
