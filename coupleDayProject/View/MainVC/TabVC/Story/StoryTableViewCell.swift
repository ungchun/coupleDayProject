import UIKit

final class StoryTableViewCell: UITableViewCell {
    
    // MARK: Properties
    //
    private var yyyyMMddDate = ""
    
    // MARK: Views
    //
    private let dayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyDayText"
        label.font = UIFont(name: "GangwonEduAllBold", size: 20)
        return label
    }()
    private let yyyyMMddDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyFormatterDayText"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .gray
        return label
    }()
    private let D_DayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "storyD_DayText"
        label.font = UIFont(name: "GangwonEduAllBold", size: 20)
        label.textColor = TrendingConstants.appMainColor
        return label
    }()
    private let divider: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    private let stackViewTopPadding: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayText,yyyyMMddDayText])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var contentHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, D_DayText])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var contentVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewTopPadding, contentHorizontalStackView, divider])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func prepareForReuse() {
        super.prepareForReuse()
        let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
        if isDark {
            self.dayText.textColor = .white
        } else {
            self.dayText.textColor = .black
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
    
    // MARK: Functions
    //
    func setStoryCellText(index: Int, beginCoupleDay: String) {
        let beginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(RealmManager.shared.getUserDatas().first!.beginCoupleDay) / 1000).toStoryString
        let tempDate = Date().millisecondsSince1970 + (index).toMillisecondsSince1970 - Int(beginCoupleDay)!.toMillisecondsSince1970
        self.yyyyMMddDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString
        dayText.text = index == 0 ? "만남의 시작" : index % 365 == 0 ? "\(index/365)주년" : "\(index) 일"
        yyyyMMddDayText.text = index == 0 ? beginCoupleFormatterDay : "\(yyyyMMddDate)"
        D_DayText.text = index == 0 || (index)-Int(beginCoupleDay)! <= 0 ? "" : "D-\((index)-Int(beginCoupleDay)!)"
        
        if index <= Int(beginCoupleDay)! {
            dayText.textColor = UIColor(white: 0.5, alpha: 0.3)
        }
    }
}
