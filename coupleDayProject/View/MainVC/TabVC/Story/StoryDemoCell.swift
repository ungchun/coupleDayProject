//
//  StoryTabView.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/10.
//

import UIKit

// cell
class StoryDemoCell: UITableViewCell {
    
    //    private let img: UIImageView = {
    //
    //        let imgView = UIImageView()
    //
    //        imgView.image = UIImage(named: "coupleImg")
    //
    //        return imgView
    //
    //    }()
    //
    //
    //
    //    // label 생성
    //
    //    private let label: UILabel = {
    //
    //        let label = UILabel()
    //
    //        label.text = "상어상어"
    //
    //        label.textColor = UIColor.gray
    //
    //        return label
    //
    //    }()
    //
    //    private func setConstraint() {
    //
    //        contentView.addSubview(img)
    //
    //        contentView.addSubview(label)
    //
    //
    //
    //        img.translatesAutoresizingMaskIntoConstraints = false
    //
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //
    //
    //
    //        NSLayoutConstraint.activate([
    //
    //            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
    //
    //            img.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
    //
    //            img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
    //
    //            img.widthAnchor.constraint(equalToConstant: 64),
    //
    //            img.heightAnchor.constraint(equalToConstant: 64),
    //
    //            label.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
    //
    //            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
    //
    //            label.centerYAnchor.constraint(equalTo: img.centerYAnchor)
    //
    //        ])
    //
    //    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(contentHorizontalStackView)
        NSLayoutConstraint.activate([
            contentHorizontalStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentHorizontalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentHorizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentHorizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
        
        //        setConstraint()
        
    }
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //        static let identifier = "StoryDemoCell"
    
    var day = 0
    var formatterDate = ""  // yyyy.MM.dd
    
    //    var testA = ""
    //    var testB = ""
    
    // MARK: init
    // UIView 하위 클래스 초기화 재정의 -> https://stackoverflow.com/questions/24339145/how-do-i-write-a-custom-init-for-a-uiview-subclass-in-swift
    // override init -> required init
    
    //        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    //            super.init(style: style, reuseIdentifier: reuseIdentifier)
    //            //        self.day = day
    ////            let tempDate = Date().millisecondsSince1970 + self.day.toMillisecondsSince1970 - Int(CoupleTabViewModel.publicBeginCoupleDay)!.toMillisecondsSince1970
    ////            self.formatterDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString // Milliseconds to Date -> toStoryString
    //            setupView()
    //        }
    //
    //        //    required init(frame: CGRect, day: Int, testA: String, testB: String) {
    //        //
    //        //        self.testA = testA
    //        //        self.testB = testB
    //        //
    //        //        self.day = day == Int.max ? 0 : day
    //        ////        let tempDate = Date().millisecondsSince1970 + self.day.toMillisecondsSince1970 - Int(CoupleTabViewModel.publicBeginCoupleDay)!.toMillisecondsSince1970
    //        //        let tempDate = Date().millisecondsSince1970 + self.day.toMillisecondsSince1970 - Int(self.testA)!.toMillisecondsSince1970
    //        //        self.formatterDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString // Milliseconds to Date -> toStoryString
    //        //
    //        //        super.init(frame: frame)
    //        //        setupView()
    //        //    }
    //
    //        required init?(coder: NSCoder) {
    //            fatalError("")
    //        }
    
    // MARK: UI
    // ㅁ 일
    lazy var storyDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //            label.text = (day % 365 == 0 && day != 0) ? "\(day/365) 주년" : day == 0 ? "만남의 시작" : "\(self.day) 일"
        label.text = "storyDayText"
        label.font = UIFont(name: "GangwonEduAllLight", size: 25)
        return label
    }()
    // yyyy.MM.dd
    lazy var storyFormatterDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //            label.text = day == 0 ? CoupleTabViewModel.publicBeginCoupleFormatterDay : "\(formatterDate)"
        label.text = "storyFormatterDayText"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .gray
        return label
    }()
    // D-10
    lazy var storyD_DayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //            label.text = day-Int(CoupleTabViewModel.publicBeginCoupleDay)! == 0 ? "D-day" : (day % 365 == 0 && day != 0 && (day-Int(CoupleTabViewModel.publicBeginCoupleDay)! > 0 )) ? "D-\(day-Int(CoupleTabViewModel.publicBeginCoupleDay)!)" : (day == 0 || (self.day-Int(CoupleTabViewModel.publicBeginCoupleDay)!) <= 0) ? "" : "D-\(self.day-Int(CoupleTabViewModel.publicBeginCoupleDay)!)"
        label.text = "storyD_DayText"
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
    //
    //    // MARK: func
    //    fileprivate func setupView() {
    //        self.contentView.addSubview(emptyView)
    //        //        self.contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    //        //        self.contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    //        //        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    //        //        self.contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    //        emptyView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    //        emptyView.rightAnchor.constraint(equalTo: self.superview!.rightAnchor).isActive = true
    //        emptyView.leftAnchor.constraint(equalTo: self.superview!.leftAnchor).isActive = true
    //        emptyView.topAnchor.constraint(equalTo: self.superview!.topAnchor).isActive = true
    //        emptyView.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor).isActive = true
    //
    //        //        self.contentView.addSubview(self.contentVerticalStackView)
    //        //        self.backgroundColor = .blue
    //        ////        self.addSubview(contentVerticalStackView)
    //        //        NSLayoutConstraint.activate([
    //        //            stackViewTopPadding.heightAnchor.constraint(equalToConstant: 0),
    //        //
    //        //            divider.heightAnchor.constraint(equalToConstant: 1),
    //        //
    //        //            contentVerticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
    //        //            contentVerticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
    //        //            contentVerticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    //        //            contentVerticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    //        //        ])
    //    }
}
