//
//  DemoFirstPage.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/05.
//

import Foundation
import UIKit

class BeginViewController: UIViewController {
    
    private var handleDateValue = Date()
    private var checkValue = false
    
    // MARK: UI
    private let guideText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        label.sizeToFit() // label 크기를 text에 맞추기
        label.text = "인연의 시작을 알려주세요"
        label.textColor = TrendingConstants.appMainColor
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.frame.size = CGSize(width: 0, height: 250)
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        // datePicker max 날짜 세팅 -> 오늘 날짜 에서
        components.year = -1
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        // datePicker min 날짜 세팅 -> 10년 전 까지
        components.year = -10
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        return datePicker
    }()
    
    private let startBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("시작하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 25)
        btn.setTitleColor(UIColor.gray, for: .normal)
        return btn
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = TrendingConstants.appMainColor
        return view
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        // set text
        button.setTitle("0일부터 시작", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 20)
        
        // set image
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: UIImage.SymbolWeight.medium, scale: UIImage.SymbolScale.large)
        let largeImage = UIImage(systemName: "square", withConfiguration: largeConfig)
        button.setImage(largeImage, for: .normal)
        let titleSize = button.titleLabel?.text!.size(withAttributes: [
            NSAttributedString.Key.font: button.titleLabel?.font as Any
        ])
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = TrendingConstants.appMainColor
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .bottom
        button.semanticContentAttribute = .forceLeftToRight
        
        button.imageEdgeInsets = UIEdgeInsets(top:0, left:-10, bottom:0, right:0)
        button.titleEdgeInsets = UIEdgeInsets(top:0, left:10, bottom:0, right:0)
        
        return button
    }()
    
    private let coupleBeginDay: UITextField = {
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
        
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged) // 날짜 변경 클릭
        checkButton.addTarget(self, action: #selector(checkButtonTap), for: .touchUpInside) // 0일부터 시작 버튼 클릭
        startBtn.addTarget(self, action: #selector(startBtnTap), for: .touchUpInside) // 시작하기 버튼 클릭
        
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
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(checkButton)
        stackView.setCustomSpacing(25, after: coupleBeginDay) // coupleBeginDay 밑으로 spacing 25 추가로 더 주기
        
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.setCustomSpacing(25, after: startBtn)
        stackView.setCustomSpacing(25, after: divider)
        
        
    }
    
    // MARK: objc
    @objc
    func handleDatePicker(_ sender: UIDatePicker) {
        coupleBeginDay.text = sender.date.toString // yyyy-MM-dd
        handleDateValue = sender.date
    }
    @objc
    func checkButtonTap() {
        if checkValue {
            checkValue.toggle()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: UIImage.SymbolWeight.medium, scale: UIImage.SymbolScale.large)
            let largeImage = UIImage(systemName: "square", withConfiguration: largeConfig)
            checkButton.setImage(largeImage, for: .normal)
        } else {
            checkValue.toggle()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: UIImage.SymbolWeight.medium, scale: UIImage.SymbolScale.large)
            let largeImage = UIImage(systemName: "checkmark.square", withConfiguration: largeConfig)
            checkButton.setImage(largeImage, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap() // extension: inputView dismiss
        setupView()
    }
    
    @objc
    func startBtnTap(completion: @escaping () -> Void) {
        // MARK: temp input realm data
        let userData = User()
        let imageData = ImageModel()
        
        var window: UIWindow?

        if checkValue {
            userData.beginCoupleDay = Int(handleDateValue.toString.toDate.millisecondsSince1970)
        } else {
            userData.beginCoupleDay = Int(Calendar.current.date(byAdding: .day, value: -1, to: handleDateValue.toString.toDate)!.millisecondsSince1970)
        }
        
        userData.zeroDayStart = checkValue
        imageData.mainImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5)
        
        RealmManager.shared.writeUserData(userData: userData)
        RealmManager.shared.writeImageData(imageData: imageData)
        
        // rootViewcontroller -> ContainerViewController 로 변경
        let rootViewcontroller = UINavigationController(rootViewController: ContainerViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewcontroller
        window?.makeKeyAndVisible()
        
        rootViewcontroller.modalTransitionStyle = .crossDissolve
        rootViewcontroller.modalPresentationStyle = .fullScreen
        self.present(rootViewcontroller, animated: true, completion: nil)
        
        // 성훈 시작페이지 추가
        // 환영합니다.
        // 당신의 인연에 ~~하길.. -> 명언으로
        // 시작하기
        // 페이지 나중에 만들어보기 애니메이션으로
    }
}
