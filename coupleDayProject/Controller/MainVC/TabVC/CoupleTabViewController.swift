//
//  ViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/22.
//

import UIKit
import RealmSwift

class CoupleTabViewController: UIViewController {

    var realm: Realm!
    
    static var publicBeginCoupleDay = ""

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
        view.image = UIImage(named: "coupleImg")
        return view
    }()

    private lazy var mainTextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "우리가 만난지"
        label.font = label.font.withSize(20)
        label.textColor = .white
        return label
    }()

    private lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = label.font.withSize(20)
        label.textColor = .white
        return label
    }()

    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    // MARK: func
    fileprivate func layoutStackView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        stackView.addArrangedSubview(mainTextSubLabel)
        stackView.addArrangedSubview(mainTextLabel)
    }

    fileprivate func layoutMainImageView() {
        realm = try? Realm()
        view.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay
        mainTextLabel.text = "\(String(describing: minus / 86400000)) days"
        CoupleTabViewController.publicBeginCoupleDay = mainTextLabel.text!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutMainImageView()
        layoutStackView()
    }
}

#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    // make UI
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        CoupleTabViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
