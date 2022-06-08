//
//  DemoFirstPage.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/05.
//

import Foundation
import UIKit
import RealmSwift

// 연애 시작일 작성 페이지
class BeginViewController: UIViewController {
    
    let realm = try! Realm()
    
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
    
    // MARK: @objc
    @objc
    func startBtnTap() {
        // MARK: temp input realm data
//        let user = realm.objects(User.self)
//        if user.isEmpty {
//            let userDate = User()
//            userDate.beginCoupleDay = Int(Date().toString.toDate.millisecondsSince1970)
//            try? self.realm.write({
//                self.realm.add(userDate)
//            })
//        }

        let mainViewController = MainContainerViewController()
        mainViewController.modalTransitionStyle = .crossDissolve
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true, completion: nil)
        // 환영합니다.
        // 당신의 인연에 ~~하길.. -> 명언으로
        // 시작하기
        // 페이지 나중에 만들어보기 애니메이션으로
    }
    
    @objc
    fileprivate func handleDatePicker(_ sender: UIDatePicker) {
        coupleBeginDay.text = sender.date.toString // yyyy-MM-dd
    }
    
    // MARK: func
    fileprivate func layoutStackView() {
        view.addSubview(stackView)
        coupleBeginDay.inputView = datePicker
        coupleBeginDay.tintColor = .clear
        coupleBeginDay.textAlignment = .center
        guideText.textAlignment = .center
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        stackView.addArrangedSubview(guideText)
        stackView.addArrangedSubview(coupleBeginDay)
        stackView.addArrangedSubview(startBtn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap() // extension: inputView dismiss
        view.backgroundColor = .white // set background color
        layoutStackView() // set view
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" ) // realm url
//                try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!) // remove realm db
    }
}

#if DEBUG
import SwiftUI
struct DemoFirstViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    // make UI
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        BeginViewController()
    }
}

struct DemoFirstViewController_Previews: PreviewProvider {
    static var previews: some View {
        DemoFirstViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
