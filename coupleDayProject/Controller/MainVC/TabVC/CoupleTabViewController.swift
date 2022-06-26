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
    static var publicBeginCoupleFormatterDay = ""
    
    private var coupleTabView: CoupleTabView!
    
    private var mainImageUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setBeginCoupleDay() // 날짜 세팅
        setMainBackgroundImage() // 메인 이미지 세팅
        setupView() // 뷰 세팅
    }
    
    // MARK: func
    fileprivate func setupView() {
        let coupleTabView = CoupleTabView(frame: self.view.frame, mainImageUrl: self.mainImageUrl)
        self.view.addSubview(coupleTabView)

        // tabView 안에 있는 View 라서 CoupleTavView 안에서 autolayout 설정하면 전체사이즈로 세팅됨. (비율에 안맞음)
        coupleTabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coupleTabView.topAnchor.constraint(equalTo: self.view.topAnchor),
            coupleTabView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            coupleTabView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            coupleTabView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
    fileprivate func setBeginCoupleDay() {
        realm = try? Realm()
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
        CoupleTabViewController.publicBeginCoupleDay = String(describing: minus / 86400000)
        CoupleTabViewController.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
    }
    fileprivate func setMainBackgroundImage() {
        realm = try? Realm()
        let realmImageData = realm.objects(Image.self)
        let mainImageUrl = realmImageData[0].mainImageUrl
        self.mainImageUrl = mainImageUrl
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
