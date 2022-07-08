//
//  LoadingViewController.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/07/07.
//

import Foundation
import UIKit
import Lottie

class LoadingViewController: UIViewController {
    
    var window: UIWindow?
    
    var animationView: AnimationView = {
        let lottieView = AnimationView(name: "lottieFile")
        lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return lottieView
    }()
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllLight", size: 50)
        label.textColor = .white
        return label
    }()
    
    lazy var stackView: UIStackView = { // 너랑나랑 + lottie
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TrendingConstants.appMainColorAlaph40
        
        // 너랑나랑 중에서 너, 나 textColor 변경
        let attributedStr = NSMutableAttributedString(string: label.text!)
        attributedStr.addAttribute(.foregroundColor, value: TrendingConstants.appMainColor, range: (label.text! as NSString).range(of:"너"))
        attributedStr.addAttribute(.foregroundColor, value: TrendingConstants.appMainColor, range: (label.text! as NSString).range(of:"나"))
        label.attributedText = attributedStr
        
//        animationView.loopMode = .loop
        animationView.loopMode = .repeat(2.5)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(animationView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 1.5),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // lottie 애니메이션
        animationView.play {(finish) in
            self.animationView.play()
            if RealmManager.shared.getUserDatas().isEmpty {
                let rootViewcontroller = UINavigationController(rootViewController: BeginViewController())
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = rootViewcontroller
                self.window?.makeKeyAndVisible()
                rootViewcontroller.modalTransitionStyle = .crossDissolve
                rootViewcontroller.modalPresentationStyle = .fullScreen
                self.present(rootViewcontroller, animated: true, completion: nil)
            } else {
                let rootViewcontroller = UINavigationController(rootViewController: ContainerViewController())
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = rootViewcontroller
                self.window?.makeKeyAndVisible()
                rootViewcontroller.modalTransitionStyle = .crossDissolve
                rootViewcontroller.modalPresentationStyle = .fullScreen
                self.present(rootViewcontroller, animated: true, completion: nil)
            }
        }
    }
}
