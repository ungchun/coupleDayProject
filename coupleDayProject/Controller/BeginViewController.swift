//
//  DemoFirstPage.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/05.
//

import Foundation
import UIKit

class BeginViewController: UIViewController {
    
    private var beginView: BeginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap() // extension: inputView dismiss
        view.backgroundColor = .white // set background color
        setupView()
    }
    
    // MARK: func
    fileprivate func setupView() {
        let beginView = BeginView(frame: self.view.frame)
        self.beginView = BeginView()
        beginView.startBtnTapAction = startBtnTap
        self.view.addSubview(beginView)
    }
    
    fileprivate func startBtnTap() {
        // MARK: temp input realm data
        //        let user = realm.objects(User.self)
        //        if user.isEmpty {
        //            let userDate = User()
        //            userDate.beginCoupleDay = Int(Date().toString.toDate.millisecondsSince1970)
        //            try? self.realm.write({
        //                self.realm.add(userDate)
        //            })
        //        }
        
        let mainViewController = ContainerViewController()
        mainViewController.modalTransitionStyle = .crossDissolve
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true, completion: nil)
        // 환영합니다.
        // 당신의 인연에 ~~하길.. -> 명언으로
        // 시작하기
        // 페이지 나중에 만들어보기 애니메이션으로
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
