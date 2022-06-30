//
//  StoryTabViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import UIKit

class StoryTabViewController: UIViewController {
    
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
    fileprivate func setupView() {
        view.addSubview(scrollView)
        view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(emptyView)
        entireStackView.addArrangedSubview(scrollView)

        for i in stride(from: 0, to: 100, by: 10) {
            if i == 0 {
                let storyTabView = StoryCell(frame: view.frame, day: Int.max)
                contentStackView.addArrangedSubview(storyTabView)
            } else {
                let storyTabView = StoryCell(frame: view.frame, day: i)
                contentStackView.addArrangedSubview(storyTabView)
            }
        }
        
        scrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 100),
            
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: emptyView.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        setupView()
    }
}
