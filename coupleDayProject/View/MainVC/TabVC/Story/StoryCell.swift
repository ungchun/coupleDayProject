//
//  StoryTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/10.
//

import UIKit

// cell
class StoryCell: UITableViewCell {
    
    private var formatterDate = "" // yyyy.MM.dd
    
    // MARK: UI
    // ㅁ 일
    private let storyDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyDayText"
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        return label
    }()
    // yyyy.MM.dd
    private let storyFormatterDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyFormatterDayText"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .gray
        return label
    }()
    // D-10
    private let storyD_DayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyD_DayText"
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        label.textColor = TrendingConstants.appMainColor
        return label
    }()
    // 하단 divider
    private let divider: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    // stackView 상단 패딩
    private let stackViewTopPadding: UILabel = {
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
        stackView.spacing = 20
        return stackView
    }()

    // MARK: func
    public func bind(index: Int) {
        let tempDate = Date().millisecondsSince1970 + (index).toMillisecondsSince1970 - Int(CoupleTabViewModel.publicBeginCoupleDay)!.toMillisecondsSince1970
        self.formatterDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString // Milliseconds to Date -> toStoryString
        storyDayText.text = index == 0 ? "만남의 시작" : index % 365 == 0 ? "\(index/365)주년" : "\(index) 일"
        storyFormatterDayText.text = index == 0 ? CoupleTabViewModel.publicBeginCoupleFormatterDay : "\(formatterDate)"
        storyD_DayText.text = index == 0 || (index)-Int(CoupleTabViewModel.publicBeginCoupleDay)! <= 0 ? "" : "D-\((index)-Int(CoupleTabViewModel.publicBeginCoupleDay)!)"
        
        if index <= Int(CoupleTabViewModel.publicBeginCoupleDay)! {
            storyDayText.textColor = UIColor(white: 0.5, alpha: 0.3)
        }

     }
    
    // MARK: init
    override func prepareForReuse() { // cell 초기화
        super.prepareForReuse()
        
        let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
        if isDark {
            self.storyDayText.textColor = .white
        } else {
            self.storyDayText.textColor = .black
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(contentVerticalStackView)
        
        self.contentVerticalStackView.backgroundColor = UIColor(named: "bgColor")

        NSLayoutConstraint.activate([
            
            divider.heightAnchor.constraint(equalToConstant: 1),

            contentVerticalStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            contentVerticalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            contentVerticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentVerticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
