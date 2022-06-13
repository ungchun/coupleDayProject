//
//  SettingView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/09.
//

import UIKit

class SettingView: UIView {
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private lazy var coupleDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "커플 날짜"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private lazy var backgroundImageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배경 사진"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private lazy var darkModeText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "다크모드"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [coupleDayText, backgroundImageText, divider, darkModeText])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 50
        return view
    }()

    // MARK: func
    fileprivate func setup() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            
            divider.widthAnchor.constraint(equalToConstant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}

