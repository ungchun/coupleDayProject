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
    
    private var coupleTabView: CoupleTabView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBeginCoupleDay() // 날짜 세팅
        setupView() // 뷰 세팅
    }
    
    // MARK: func
    fileprivate func setupView() {
        let coupleTabView = CoupleTabView(frame: self.view.frame)
        self.coupleTabView = CoupleTabView()
        self.view.addSubview(coupleTabView)
    }

    fileprivate func setBeginCoupleDay() {
        realm = try? Realm()
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
        CoupleTabViewController.publicBeginCoupleDay = String(describing: minus / 86400000)
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
