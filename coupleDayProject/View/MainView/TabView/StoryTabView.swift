//
//  StoryTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/10.
//

import UIKit

class StoryTabView: UIView {
    
    let coupleTabViewModel = CoupleTabViewModel()
    
    var day: Int // ㅁ 일
    var formatterDate: String // yyyy.MM.dd
    
    // MARK: init
    // UIView 하위 클래스 초기화 재정의 -> https://stackoverflow.com/questions/24339145/how-do-i-write-a-custom-init-for-a-uiview-subclass-in-swift
    // override init -> required init
    required init(frame: CGRect, day: Int) {
        self.day = day == Int.max ? 0 : day
//        let tempDate = Date().millisecondsSince1970 + self.day.toMillisecondsSince1970 - Int(CoupleTabViewController.publicBeginCoupleDay)!.toMillisecondsSince1970
        let tempDate = Date().millisecondsSince1970 + self.day.toMillisecondsSince1970 - Int(coupleTabViewModel.publicBeginCoupleDay)!.toMillisecondsSince1970
        self.formatterDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString // Milliseconds to Date -> toStoryString    
        
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
        view.text = self.day == 0 ? "만남의 시작" : "\(self.day) 일"
        view.backgroundColor = .gray
        return view
    }()
    // yyyy.MM.dd
    private lazy var storyFormatterDayText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.text = day == 0 ? CoupleTabViewController.publicBeginCoupleFormatterDay : "\(formatterDate)"
        view.text = day == 0 ? coupleTabViewModel.publicBeginCoupleFormatterDay : "\(formatterDate)"
        view.backgroundColor = .blue
        return view
    }()
    // D-10
    private lazy var storyD_DayText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.text = day == 0 ? "" : "D-\(self.day-Int(CoupleTabViewController.publicBeginCoupleDay)!)"
        view.text = day == 0 ? "" : "D-\(self.day-Int(coupleTabViewModel.publicBeginCoupleDay)!)"
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
    // stackView 상단 패딩
    private lazy var stackViewTopPadding: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    // stackView 에서 가운데 날짜 관련 택스트 view
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storyDayText,storyFormatterDayText])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    // 날짜 관련 택스트 vertical 스택 뷰 + D-day 합친 horizontal 스택 뷰
    private lazy var contentHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, storyD_DayText])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
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
    
    // MARK: func
    fileprivate func setup() {
        self.addSubview(contentVerticalStackView)
        NSLayoutConstraint.activate([
            stackViewTopPadding.heightAnchor.constraint(equalToConstant: 5),
            
            divider.heightAnchor.constraint(equalToConstant: 5),
            
            contentVerticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentVerticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            contentVerticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentVerticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
