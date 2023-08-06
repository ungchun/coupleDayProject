import UIKit

final class StoryTableViewCell: UITableViewCell {
	
	//MARK: - Properties
	
	private var yyyyMMddDate = ""
	
	//MARK: - Views
	
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
	
	private lazy var dayAndyyyyMMddDayView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [dayText, yyyyMMddDayText])
		stackView.axis = .vertical
		stackView.spacing = 2
		stackView.alignment = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	private lazy var _contentView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [dayAndyyyyMMddDayView, D_DayText])
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .equalCentering
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	private lazy var contentViewWithPadding: UIStackView = {
		let stackView = UIStackView(
			arrangedSubviews: [stackViewTopPadding, _contentView, divider]
		)
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.spacing = 0
		return stackView
	}()
	
	//MARK: - Life Cycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(contentViewWithPadding)
		
		self.contentViewWithPadding.backgroundColor = UIColor(named: "bgColor")
		
		NSLayoutConstraint.activate([
			divider.heightAnchor.constraint(equalToConstant: 1),
			
			contentViewWithPadding.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
			contentViewWithPadding.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
			contentViewWithPadding.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			contentViewWithPadding.topAnchor.constraint(equalTo: contentView.topAnchor),
		])
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		let isDarkMode = UserDefaultsSetting.isDarkMode
		if isDarkMode {
			self.dayText.textColor = .white
		} else {
			self.dayText.textColor = .black
		}
	}
}

extension StoryTableViewCell {
	
	//MARK: - Functions
	
	func setStoryCellText(index: Int, beginCoupleDay: String) {
		if let userDatas = RealmService.shared.getUserDatas().first {
			let beginCoupleFormatterDay = Date(
				timeIntervalSince1970: TimeInterval(userDatas.beginCoupleDay) / 1000
			).toStoryString
			let tempDate = Date().millisecondsSince1970 + (index).toMillisecondsSince1970 - (Int(beginCoupleDay)?.toMillisecondsSince1970 ?? 0)
			self.yyyyMMddDate = Date(timeIntervalSince1970: TimeInterval(tempDate) / 1000).toStoryString
			dayText.text = index == 0 ? "만남의 시작" : index % 365 == 0 ? "\(index/365)주년" : "\(index) 일"
			yyyyMMddDayText.text = index == 0 ? beginCoupleFormatterDay : "\(yyyyMMddDate)"
			D_DayText.text = index == 0 || (index)-(Int(beginCoupleDay) ?? 0) <= 0 ? "" : "D-\((index)-(Int(beginCoupleDay) ?? 0))"
			
			if index <= Int(beginCoupleDay) ?? 0 {
				dayText.textColor = UIColor(white: 0.5, alpha: 0.3)
			}
		}
	}
}
