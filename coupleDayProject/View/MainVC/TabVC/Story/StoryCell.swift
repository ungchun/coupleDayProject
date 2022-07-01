//
//  StoryTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/10.
//

import UIKit

// cell
class StoryCell: UIView {
    
    var day: Int // ㅁ 일
    var formatterDate: String // yyyy.MM.dd
    
    var testA = ""
    var testB = ""
    
    // MARK: init
    // UIView 하위 클래스 초기화 재정의 -> https://stackoverflow.com/questions/24339145/how-do-i-write-a-custom-init-for-a-uiview-subclass-in-swift
    // override init -> required init
    required init(frame: CGRect, day: Int, testA: String, testB: String) {
        self.testA = testA
        self.testB = testB
        
        self.day = day == Int.max ? 0 : day
//        let tempDate = Date().millisecondsSince1970 + self.day.toMillisecondsSince1970 - Int(CoupleTabViewModel.publicBeginCoupleDay)!.toMillisecondsSince1970
        let tempDate = Date().millisecondsSince1970 + self.day.toMillisecondsSince1970 - Int(self.testA)!.toMillisecondsSince1970
        self.formatterDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString // Milliseconds to Date -> toStoryString
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    // ㅁ 일
    lazy var storyDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = (day % 365 == 0 && day != 0) ? "\(day/365) 주년" : day == 0 ? "만남의 시작" : "\(self.day) 일"
        label.font = UIFont(name: "GangwonEduAllLight", size: 25)
        return label
    }()
    // yyyy.MM.dd
    lazy var storyFormatterDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = day == 0 ? CoupleTabViewModel.publicBeginCoupleFormatterDay : "\(formatterDate)"
        label.text = day == 0 ? self.testB : "\(formatterDate)"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .gray
        return label
    }()
    // D-10
    lazy var storyD_DayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = day-Int(self.testA)! == 0 ? "D-day" : (day % 365 == 0 && day != 0 && (day-Int(self.testA)! > 0 )) ? "D-\(day-Int(self.testA)!)" : (day == 0 || (self.day-Int(self.testA)!) <= 0) ? "" : "D-\(self.day-Int(self.testA)!)"
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        label.textColor = TrendingConstants.appMainColor
        return label
    }()
    // 하단 divider
    private lazy var divider: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
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
    fileprivate func setupView() {
        self.addSubview(contentVerticalStackView)
        NSLayoutConstraint.activate([
            stackViewTopPadding.heightAnchor.constraint(equalToConstant: 0),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            contentVerticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentVerticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            contentVerticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentVerticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
