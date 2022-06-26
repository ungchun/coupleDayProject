//
//  ImageCheckViewController.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/15.
//

import UIKit
import RealmSwift

protocol SendImageUrlDelegate {
    func sendImageUrl(imageUrl: URL)
}

extension ImageCheckViewController: SendImageUrlDelegate {}

class ImageCheckViewController: UIViewController {
    
    var realm: Realm!
    
    private var imageCheckView: ImageCheckView!
    
    private var imageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingViewController = SettingViewController()
        settingViewController.sendImageUrlDelegate = self
        view.backgroundColor = .white
        setupView()
    }
    
    // MARK: func
    fileprivate func setupView() {
        let imageCheckView = ImageCheckView(frame: self.view.frame, imageUrl: self.imageUrl!)
        imageCheckView.selectBtnTapAction = selectionTap
        self.imageCheckView = imageCheckView
        self.view.addSubview(imageCheckView)
    }
    fileprivate func selectionTap() {
        print("selectTap in VC")
        realm = try? Realm()
        let imageData = realm.objects(Image.self)
        try! realm.write {
            let data = try? Data(contentsOf: self.imageUrl!)
            imageData.first?.mainImageUrl = data
//            CoupleTabViewController().refreshView()
//            imageData.first?.mainImageUrl = String(describing: self.imageUrl!)
            dismiss(animated: true, completion: nil)
        }
        
        print("self.imageUrl! \(self.imageUrl!)")
    }
    func sendImageUrl(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
}
