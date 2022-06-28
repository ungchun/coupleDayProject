//
//  CoupleTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/09.
//

import UIKit
import RealmSwift

class CoupleTabView: UIView {
    
    var myProfileAction: (() -> Void)?
    var partnerProfileAction: (() -> Void)?
    
    var realm: Realm!
    
    private var mainImageData: Data!
    private var myProfileImageData: Data!
    private var partnerProfileImageData: Data!
    
    // MARK: init
    required init(frame: CGRect, mainImageUrl: Data, myProfileImageData: Data, partnerProfileImageData: Data) {
        super.init(frame: frame)
        self.mainImageData = mainImageUrl
        self.myProfileImageData = myProfileImageData
        self.partnerProfileImageData = partnerProfileImageData
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    
    private lazy var demoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var demoView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var demoView2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coupleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var myProfileUIImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 50
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myProfileTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.image = UIImage(data: self.myProfileImageData)
        
        return view
    }()
    private lazy var partnerProfileUIImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .purple
        view.layer.cornerRadius = 50
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.image = UIImage(data: self.partnerProfileImageData)
        return view
    }()
    private var iconDayStackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var loveIconView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: objc
    @objc
    func myProfileTap(_ gesture: UITapGestureRecognizer) {
        print("myProfileTap")
//        myProfileAction!()
    }
    @objc
    func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
        print("partnerProfileTap")
//        partnerProfileAction!()
    }
    
    // MARK: func
    fileprivate func setup() {
        
        addSubview(demoStackView)
        demoStackView.addArrangedSubview(demoView)
        demoStackView.addArrangedSubview(mainImageView)
        
        demoStackView.addArrangedSubview(coupleStackView)
        coupleStackView.addArrangedSubview(myProfileUIImageView)
        coupleStackView.addArrangedSubview(iconDayStackView)
        coupleStackView.addArrangedSubview(partnerProfileUIImageView)
        iconDayStackView.addArrangedSubview(loveIconView)
        
        myProfileUIImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        myProfileUIImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        let myTapGesture = UITapGestureRecognizer(target: self, action: #selector(myProfileTap(_:)))
//        myProfileUIImageView.addGestureRecognizer(myTapGesture)
        
        partnerProfileUIImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        partnerProfileUIImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        let partnerTapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:)))
//        partnerProfileUIImageView.addGestureRecognizer(partnerTapGesture)
        
        loveIconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loveIconView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        demoStackView.addArrangedSubview(demoView2)
        
        demoView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        demoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        coupleStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        NSLayoutConstraint.activate([
            demoStackView.topAnchor.constraint(equalTo: self.topAnchor),
            demoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            demoStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            demoStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
        
        
        
        
        
        //        layoutMainImageView()
        //        layoutStackView()
    }

    private lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.contentMode = .scaleAspectFill
        //        view.contentMode = .scaleAspectFit
        view.image = UIImage(data: self.mainImageData)
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
            mainImageView.topAnchor.constraint(equalTo: self.demoStackView.bottomAnchor),
            //            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            //            mainImageView.heightAnchor.constraint(equalToConstant: 300),
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
