//
//  BeginView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/09.
//

import UIKit
import RealmSwift

class BeginView: UIView {
    
    let realm = try! Realm()
    
    var handleDatePickerAction: (() -> Void)? // handleDatePickerAction
    var startBtnTapAction: (() -> Void)? // startBtnTapAction
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" ) // realm url
//                try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!) // remove realm db
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI
    private lazy var guideText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit() // label 크기를 text에 맞추기
        label.text = "인연의 시작을 알려주세요!"
        label.textColor = TrendingConstants.appMainColor
        label.font = label.font.withSize(20)
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
        textField.font = .systemFont(ofSize: 30)
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
    fileprivate func setup() {
        addSubview(stackView)
        coupleBeginDay.inputView = datePicker
        coupleBeginDay.tintColor = .clear
        coupleBeginDay.textAlignment = .center
        guideText.textAlignment = .center
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        stackView.addArrangedSubview(guideText)
        stackView.addArrangedSubview(coupleBeginDay)
        stackView.addArrangedSubview(startBtn)
    }
    
    // MARK: objc
    @objc
    func handleDatePicker(_ sender: UIDatePicker) {
        coupleBeginDay.text = sender.date.toString // yyyy-MM-dd
        handleDatePickerAction!()
    }
    @objc
    func startBtnTap() {
        startBtnTapAction!()
    }
}
