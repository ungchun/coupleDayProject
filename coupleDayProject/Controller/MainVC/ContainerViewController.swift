//
//  MainContainerViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/29.
//

import UIKit
import RealmSwift

class ContainerViewController: UIViewController {
    
    private var containerView: ContainerView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true // 상단 NavigationBar 공간 hidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // set background color
        setupView() // 뷰 세팅
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" ) // realm url
    }
    
    // MARK: func
    fileprivate func setupView() {
        let containerView = ContainerView(frame: self.view.frame)
        self.containerView = ContainerView()
        self.view.addSubview(containerView)
        containerView.setBtnAction = setBtnTap // containerView 에 있는 btnAction 이랑 setBtnTap 연결
        
        let mainTabManVC = TabManViewController()
        addChild(mainTabManVC)
        view.addSubview(mainTabManVC.view)
        mainTabManVC.didMove(toParent: self)
        mainTabManVC.view.translatesAutoresizingMaskIntoConstraints = false
        mainTabManVC.view.topAnchor.constraint(equalTo: containerView.stackView.bottomAnchor).isActive = true
        mainTabManVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainTabManVC.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainTabManVC.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    fileprivate func setBtnTap() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
}

#if DEBUG
import SwiftUI
struct MainContainerViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    // make UI
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        ContainerViewController()
    }
}

struct MainContainerViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainContainerViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
