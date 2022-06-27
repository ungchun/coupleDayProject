//
//  ImageCheckViewController.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/15.
//

import UIKit
import RealmSwift

protocol SendImageUrlDelegate {
    func sendImageUrl(imageUrl: UIImage)
}

extension ImageCheckViewController: SendImageUrlDelegate {}

class ImageCheckViewController: UIViewController {
    
    var refreshImageCheckDelegate: RefreshImageDelegate?
    
    var realm: Realm!
    
    private var imageCheckView: ImageCheckView!
    
    private var imageUrl: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingViewController = SettingViewController()
        settingViewController.sendImageUrlDelegate = self
        view.backgroundColor = .white
        setupView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    // MARK: func
    fileprivate func setupView() {
        let imageCheckView = ImageCheckView(frame: self.view.frame, imageUrl: self.imageUrl!)
        imageCheckView.selectBtnTapAction = selectionTap
        self.imageCheckView = imageCheckView
        self.view.addSubview(imageCheckView)
    }
    fileprivate func selectionTap() {
//        realm = try? Realm()
//        let imageData = realm.objects(Image.self)
//        try! realm.write {
//            let data = try? Data(contentsOf: imageUrl!)
//            imageData.first?.mainImageUrl = data
//
//            // present 로 넘어와서 dismiss 하고 네비게이션컨에서 popToRoot
//            guard let pvc = presentingViewController as? UINavigationController else { return }
//            dismiss(animated: true) {
//                let coupleTabViewController = CoupleTabViewController()
//                coupleTabViewController.refreshImage(refreshImageCheck: true)
//                pvc.popToRootViewController(animated: true)
//            }
//        }
    }
    func sendImageUrl(imageUrl: UIImage) {
        self.imageUrl = imageUrl
    }
}
