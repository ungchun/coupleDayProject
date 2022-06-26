//
//  ImageCheckViewController.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/15.
//

import UIKit

protocol SendImageUrlDelegate {
    func sendImageUrl(imageUrl: URL)
}

extension ImageCheckViewController: SendImageUrlDelegate {}

class ImageCheckViewController: UIViewController {
    
    private var imageCheckView: ImageCheckView!
//    var image: UIImage?
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
//        let imageCheckView = ImageCheckView(frame: self.view.frame, image: image!)
        let imageCheckView = ImageCheckView(frame: self.view.frame, imageUrl: self.imageUrl!)
        imageCheckView.selectBtnTapAction = selectionTap
        self.imageCheckView = imageCheckView
        self.view.addSubview(imageCheckView)
    }
    fileprivate func selectionTap() {
        print("selectTap in VC")
        
    }
    
    func sendImageUrl(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
}
