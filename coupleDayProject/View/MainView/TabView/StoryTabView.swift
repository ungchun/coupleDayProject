//
//  StoryTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/10.
//

import UIKit

class StoryTabView: UIView {
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    // ㅁ 일
    private lazy var storyDayText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "10일"
        view.backgroundColor = .gray
        return view
    }()
    // yyyy.MM.dd
    private lazy var storyFormatterDayText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "2022.06.06(월)"
        view.backgroundColor = .blue
        return view
    }()
    // D-10
    private lazy var storyD_DayText: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "D-10"
        view.backgroundColor = .gray
        return view
    }()
    // 하단 divider
    private lazy var divider: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    // 상단 탭이랑 안겹치게 주는 뷰
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        return view
    }()
    private lazy var stackViewTopPadding: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    // stackView 에서 가운데 날짜 관련 택스트 view
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storyDayText,storyFormatterDayText])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var contentHorizontalStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [textStackView, storyD_DayText])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
//        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    // 위 아래 패딩 + divider -> stackView
    private lazy var contentVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewTopPadding, contentHorizontalStackView, divider])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 30
        return stackView
    }()


    
    // emptyView + scrollView (stackView)
    private lazy var EntireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyView, contentVerticalStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: func
    fileprivate func setup() {
        self.addSubview(scrollView)
        scrollView.addSubview(EntireStackView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: self.topAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 100),
            
            stackViewTopPadding.heightAnchor.constraint(equalToConstant: 5),
            
            divider.heightAnchor.constraint(equalToConstant: 5),
            
            EntireStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            EntireStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            EntireStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            EntireStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            EntireStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
