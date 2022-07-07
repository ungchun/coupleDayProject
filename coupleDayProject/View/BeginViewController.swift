//
//  DemoFirstPage.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/05.
//

import Foundation
import UIKit
import RealmSwift

class BeginViewController: UIViewController {
    
    var realm = try! Realm()
    
    private var handleDateValue = Date()
    
    // MARK: UI
    private lazy var guideText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        label.sizeToFit() // label 크기를 text에 맞추기
        label.text = "인연의 시작을 알려주세요"
        label.textColor = TrendingConstants.appMainColor
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        return datePicker
    }()
    
    private lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("시작하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 25)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(startBtnTap), for: .touchUpInside)
        return btn
    }()
    
    private lazy var coupleBeginDay: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "yyyy-MM-dd"
        textField.text = formatter.string(from: Date())
        textField.font = UIFont(name: "GangwonEduAllBold", size: 40)
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    // MARK: func
    fileprivate func setupView() {
        view.backgroundColor = TrendingConstants.appMainColorAlaph40 // set background color
        view.addSubview(stackView)
        coupleBeginDay.inputView = datePicker
        coupleBeginDay.tintColor = .clear
        coupleBeginDay.textAlignment = .center
        guideText.textAlignment = .center
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        stackView.addArrangedSubview(guideText)
        stackView.addArrangedSubview(coupleBeginDay)
        stackView.addArrangedSubview(startBtn)
        stackView.setCustomSpacing(30, after: coupleBeginDay) // coupleBeginDay 밑으로 spacing 30 추가로 더 주기
    }
    
    // MARK: objc
    @objc
    func handleDatePicker(_ sender: UIDatePicker) {
        coupleBeginDay.text = sender.date.toString // yyyy-MM-dd
        handleDateValue = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap() // extension: inputView dismiss
        setupView()
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" ) // realm url
        //                try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!) // remove realm db
    }
    
    @objc
    func startBtnTap(completion: @escaping () -> Void) {
        // MARK: temp input realm data
        let userDate = User()
        let imageDate = Image()
        
        var window: UIWindow?
        
        userDate.beginCoupleDay = Int(handleDateValue.toString.toDate.millisecondsSince1970)
        imageDate.mainImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5)
        imageDate.myProfileImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5)
        imageDate.partnerProfileImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5)
        
        // 성훈 realm 처리
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ungchun.coupleDayProject")?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: path)
        self.realm = try! Realm(configuration: config)
        
        try? realm.write({
            realm.add(userDate)
            realm.add(imageDate)
            
            // rootViewcontroller -> ContainerViewController 로 변경
            let rootViewcontroller = UINavigationController(rootViewController: ContainerViewController())
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = rootViewcontroller
            window?.makeKeyAndVisible()
            
            rootViewcontroller.modalTransitionStyle = .crossDissolve
            rootViewcontroller.modalPresentationStyle = .fullScreen
            self.present(rootViewcontroller, animated: true, completion: nil)
        })
        
        // 성훈 시작페이지 추가
        // 환영합니다.
        // 당신의 인연에 ~~하길.. -> 명언으로
        // 시작하기
        // 페이지 나중에 만들어보기 애니메이션으로
    }
}
