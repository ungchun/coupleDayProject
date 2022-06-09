//
//  CoupleTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/09.
//

import UIKit
import RealmSwift

class CoupleTabView: UIView {
    
    var realm: Realm!
    
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private lazy var mySecondeView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // cornerRadius -> 이거 관련한것은 clipsToBounds true 해줘야함
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "coupleImg")
        return view
    }()
    
    private lazy var mainTextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "우리가 만난지"
        label.font = label.font.withSize(20)
        label.textColor = .white
        return label
    }()
    
    private lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = label.font.withSize(20)
        label.textColor = .white
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: func
    fileprivate func setup() {
        layoutMainImageView()
        layoutStackView()
    }
    
    fileprivate func layoutMainImageView() {
        addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        mainTextLabel.text = "\(CoupleTabViewController.publicBeginCoupleDay) days"
    }
    
    fileprivate func layoutStackView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        stackView.addArrangedSubview(mainTextSubLabel)
        stackView.addArrangedSubview(mainTextLabel)
    }
    
}
