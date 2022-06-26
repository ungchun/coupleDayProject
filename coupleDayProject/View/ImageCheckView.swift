//
//  ImageCheckView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/15.
//

import UIKit

class ImageCheckView: UIView {
    
    var selectBtnTapAction: (() -> Void)?
    
//    var image: UIImage
    var imageUrl: URL
    
    // MARK: init
    required init(frame: CGRect, imageUrl: URL) {
        self.imageUrl = imageUrl
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
//        imageView.image = image
        imageView.load(url: self.imageUrl)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var selectionBtn: UIButton = {
       let btn = UIButton()
        btn.setTitle("이 사진으로 선택", for: .normal)
        btn.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 15)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(selectionTap), for: .touchUpInside)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()
    
    // MARK: objc
    @objc
    func selectionTap() {
        
        selectBtnTapAction!()
    }
    
    // MARK: func
    fileprivate func setup() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalToConstant: self.frame.width / 1.5),
            backgroundImageView.heightAnchor.constraint(equalToConstant: self.frame.height / 1.5),
            selectionBtn.heightAnchor.constraint(equalToConstant: 45),
            
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        stackView.addArrangedSubview(backgroundImageView)
        stackView.addArrangedSubview(selectionBtn)
    }
}

