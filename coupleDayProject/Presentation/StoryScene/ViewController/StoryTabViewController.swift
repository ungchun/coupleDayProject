import UIKit

final class StoryTabViewController: BaseViewController {
	
	//MARK: - Properties
	
	var coupleTabViewModel: CoupleTabViewModel?
	
	//MARK: - Views
	
	private let topEmptyView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let storyTableView = StoryTableView()
	
	private let contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .equalSpacing
		stackView.spacing = 0
		return stackView
	}()
	
	//MARK: - Life Cycle
	
	init(coupleTabViewModel: CoupleTabViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.coupleTabViewModel = coupleTabViewModel
		storyTableView.coupleTabViewModel = self.coupleTabViewModel
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(receiveCoupleDayData(notification:)),
			name: Notification.Name.coupleDay, object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(changeDarkModeSet(notification:)),
			name: Notification.Name.darkModeCheck, object: nil
		)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		storyTableViewScrollToRow(coupleDay: nil)
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.view.addSubview(contentView)
		contentView.addArrangedSubview(topEmptyView)
		contentView.addArrangedSubview(storyTableView)
		
		NSLayoutConstraint.activate([
			topEmptyView.topAnchor.constraint(equalTo: view.topAnchor),
			topEmptyView.heightAnchor.constraint(equalToConstant: 70),
			
			storyTableView.topAnchor.constraint(equalTo: self.topEmptyView.bottomAnchor),
			storyTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			storyTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			storyTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
	}
	
	override func setupView() {
		self.view.backgroundColor = UIColor(named: "bgColor")
	}
}

private extension StoryTabViewController {
	
	@objc func receiveCoupleDayData(notification: Notification) {
		guard let coupleDay = notification.userInfo?["coupleDay"] as? String else { return }
		DispatchQueue.main.async { [weak self] in
			self?.storyTableView.reloadData()
			self?.storyTableViewScrollToRow(coupleDay: coupleDay)
		}
	}
	
	@objc func changeDarkModeSet(notification: Notification) {
		DispatchQueue.main.async { [weak self] in
			self?.storyTableView.reloadData()
		}
	}
	
	func storyTableViewScrollToRow(coupleDay: String?) {
		guard let coupleTabViewModel = coupleTabViewModel else { return }
		var coupleDayToInt = 0
		if coupleDay == nil {
			coupleDayToInt = Int((coupleTabViewModel.output.beginCoupleDayOutput.value)) ?? 0
		} else {
			coupleDayToInt = Int(coupleDay ?? "") ?? 0
		}
		
		if coupleDayToInt >= 10950 {
			let startIndex = IndexPath(row: StoryStandardDay().dayValues.count-1, section: 0)
			self.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
		} else {
			let startIndex = IndexPath(
				row: StoryStandardDay().dayValues.firstIndex(
					of: StoryStandardDay().dayValues.filter {
						$0 > coupleDayToInt
					}.min() ?? 0) ?? 0,
				section: 0
			)
			self.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
		}
	}
}
