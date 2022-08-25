import UIKit

final class StoryCell: UITableViewCell {
    
    // MARK: Properties
    //
    private var formatterDate = "" // yyyy.MM.dd
    
    // MARK: Views
    //
    private let storyDayText: UILabel = { // ㅁ 일
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyDayText"
        label.font = UIFont(name: "GangwonEduAllBold", size: 20)
        return label
    }()
    private let storyFormatterDayText: UILabel = { // yyyy.MM.dd
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyFormatterDayText"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .gray
        return label
    }()
    private let storyD_DayText: UILabel = { // D-10
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyD_DayText"
        label.font = UIFont(name: "GangwonEduAllBold", size: 20)
        label.textColor = TrendingConstants.appMainColor
        return label
    }()
    private let divider: UILabel = { // 하단 divider
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    private let stackViewTopPadding: UILabel = { // stackView 상단 패딩
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var textStackView: UIStackView = { // stackView 에서 가운데 날짜 관련 택스트 view
        let stackView = UIStackView(arrangedSubviews: [storyDayText,storyFormatterDayText])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var contentHorizontalStackView: UIStackView = { // 날짜 관련 택스트 vertical 스택 뷰 + D-day 합친 horizontal 스택 뷰
        let stackView = UIStackView(arrangedSubviews: [textStackView, storyD_DayText])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var contentVerticalStackView: UIStackView = { // 위 아래 패딩 + divider -> stackView
        let stackView = UIStackView(arrangedSubviews: [stackViewTopPadding, contentHorizontalStackView, divider])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    // cell은 재사용되기 때문에 prepareForReuse 이용해서 cell 초기화해줘야함
    //
    override func prepareForReuse() {
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
        
        // set autolayout
        //
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
    
    // MARK: Functions
    //
    // cell text 값 세팅
    //
    public func bind(index: Int, beginCoupleDay: String) {
        let beginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(RealmManager.shared.getUserDatas().first!.beginCoupleDay) / 1000).toStoryString
        let tempDate = Date().millisecondsSince1970 + (index).toMillisecondsSince1970 - Int(beginCoupleDay)!.toMillisecondsSince1970
        self.formatterDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString // yyyy.MM.dd
        storyDayText.text = index == 0 ? "만남의 시작" : index % 365 == 0 ? "\(index/365)주년" : "\(index) 일"
        storyFormatterDayText.text = index == 0 ? beginCoupleFormatterDay : "\(formatterDate)"
        storyD_DayText.text = index == 0 || (index)-Int(beginCoupleDay)! <= 0 ? "" : "D-\((index)-Int(beginCoupleDay)!)"
        
        if index <= Int(beginCoupleDay)! {
            storyDayText.textColor = UIColor(white: 0.5, alpha: 0.3)
        }
    }
}
