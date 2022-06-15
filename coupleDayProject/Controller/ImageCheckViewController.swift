//
//  ImageCheckViewController.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/15.
//

import UIKit

class ImageCheckViewController: UIViewController {
    
    private var imageCheckView: ImageCheckView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    // MARK: func
    fileprivate func setupView() {
        let imageCheckView = ImageCheckView(frame: self.view.frame, image: image!)
        self.imageCheckView = imageCheckView
        self.view.addSubview(imageCheckView)
    }
}
