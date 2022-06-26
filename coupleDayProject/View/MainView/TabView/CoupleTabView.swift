//
//  CoupleTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/09.
//

import UIKit
import RealmSwift

class CoupleTabView: UIView {
    
    var realm: Realm!
    private var mainImageUrl: Data!
    
    // MARK: init
    required init(frame: CGRect, mainImageUrl: Data) {
        super.init(frame: frame)
        self.mainImageUrl = mainImageUrl
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private lazy var mySecondeView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // cornerRadius -> 이거 관련한것은 clipsToBounds true 해줘야함
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentMode = .scaleAspectFill
//        view.contentMode = .scaleAspectFit
        view.image = UIImage(data: self.mainImageUrl)
        return view
    }()
    
    private lazy var mainTextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "우리가 만난지"
        label.font = UIFont(name: "GangwonEduAllLight", size: 25)
        label.textColor = .white
        return label
    }()
    
    private lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "GangwonEduAllBold", size: 35)
        label.textColor = .white
        return label
    }()
    
    private lazy var centerTextStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [mainTextSubLabel, mainTextLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mainTextSubLabel.textAlignment = .center
        mainTextLabel.textAlignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        //        stackView.distribution = .fillProportionally
        //        stackView.alignment = .center
        return stackView
    }()
    
    
    private lazy var testLabel_0: UILabel = {
        var label = UILabel()
        label.text = "다가오는 기념일"
        return label
    }()
    private lazy var testLabel_1: UILabel = {
        var label = UILabel()
        label.text = "생일"
        return label
    }()
    private lazy var testLabel_2: UILabel = {
        var label = UILabel()
        label.text = "D-100"
        return label
    }()
    private lazy var testLabel_3: UILabel = {
        var label = UILabel()
        label.text = "로즈데이"
        return label
    }()
    
    private lazy var comingStoryStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [testLabel_0, testLabel_1, testLabel_2, testLabel_3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: func
    fileprivate func setup() {
        layoutMainImageView()
        layoutStackView()
    }
    
    fileprivate func layoutMainImageView() {
//        mainImageView.image = UIImage(named: "coupleImg")
//        if self.mainImageUrl == "" {
//            mainImageView.image = UIImage(named: "coupleImg")
//        } else {
//            print("self.mainImageUrl \(self.mainImageUrl!)")
//            mainImageView.load(url: URL(string: self.mainImageUrl!)!)
//        }
//    https://images.unsplash.com/photo-1503435980610-a51f3ddfee50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80
        
        addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
        mainTextLabel.text = "\(CoupleTabViewController.publicBeginCoupleDay) days"
    }
    
    fileprivate func layoutStackView() {
        addSubview(centerTextStackView)
//        addSubview(comingStoryStackView)
//        centerTextStackView.backgroundColor = .blue
//        comingStoryStackView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            centerTextStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centerTextStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
//            comingStoryStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
//            comingStoryStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50)
        ])
        
        
        
    }
    
}
