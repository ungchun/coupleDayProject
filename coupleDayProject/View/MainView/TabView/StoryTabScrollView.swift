//
//  StoryTabScrollView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/12.
//

import UIKit

class StoryTabScrollView: UIView {
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 상단 탭이랑 안겹치게 주는 뷰
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        return view
    }()

    // scrollView (stackView)
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        //        let stackView = UIStackView(arrangedSubviews: [emptyView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    // emptyView + contentStackView
    private lazy var entireStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: func
    fileprivate func setup() {
        self.addSubview(entireStackView)
        entireStackView.addArrangedSubview(emptyView)
        entireStackView.addArrangedSubview(scrollView)

        for i in stride(from: 0, to: 100, by: 10) {
            if i == 0 {
                let storyTabView = StoryTabView(frame: self.frame, day: Int.max)
                contentStackView.addArrangedSubview(storyTabView)
            } else {
                let storyTabView = StoryTabView(frame: self.frame, day: i)
                contentStackView.addArrangedSubview(storyTabView)
            }
            
        }
        
        scrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            
            emptyView.topAnchor.constraint(equalTo: self.topAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 100),
            
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: emptyView.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
    }
    
}
