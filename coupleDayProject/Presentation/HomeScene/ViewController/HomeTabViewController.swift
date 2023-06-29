import UIKit

import Pageboy
import Tabman

final class HomeTabViewController: TabmanViewController {
	
	//MARK: - Properties
	
	private var coupleTabViewModel: CoupleTabViewModel?
	private var viewControllers: Array<UIViewController> = []
	
	//MARK: - Life Cycle
	
	init(coupleTabViewModel: CoupleTabViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.coupleTabViewModel = coupleTabViewModel
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
	}
}

private extension HomeTabViewController {
	
	//MARK: - Functions
	
	private func setupLayout() {
		guard let coupleTabViewModel = coupleTabViewModel else { return }
		let coupleTabViewController = CoupleViewController(coupleTabViewModel: coupleTabViewModel)
		let storyTabViewController = StoryTabViewController(coupleTabViewModel: coupleTabViewModel)
		viewControllers.append(coupleTabViewController)
		viewControllers.append(storyTabViewController)
		
		self.dataSource = self
		
		let bar = TMBar.ButtonBar()
		bar.backgroundView.style = .clear
		bar.backgroundColor = UIColor(named: "bgColor")
		bar.buttons.customize { (button) in
			button.tintColor = UIColor(white: 0.5, alpha: 0.3)
			button.selectedTintColor = TrendingConstants.appMainColor
			button.font = UIFont(
				name: "GangwonEduAllBold",
				size: 20
			) ?? UIFont.systemFont(ofSize: 20)
		}
		bar.layout.transitionStyle = .snap
		bar.layout.interButtonSpacing = 20
		bar.indicator.weight = .custom(value: 2.5)
		bar.indicator.tintColor = TrendingConstants.appMainColor
		bar.layout.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
		bar.indicator.overscrollBehavior = .bounce
		addBar(bar, dataSource: self, at: .top)
	}
}

extension HomeTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
	func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
		let item = TMBarItem(title: "")
		let title: String = index == 0 ? "커플" : "스토리"
		item.title = title
		return item
	}
	
	func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
		return viewControllers.count
	}
	
	func viewController (
		for pageboyViewController: PageboyViewController,
		at index: PageboyViewController.PageIndex
	) -> UIViewController? {
		return viewControllers[index]
	}
	
	func defaultPage (
		for pageboyViewController: PageboyViewController
	) -> PageboyViewController.Page? {
		return .at(index: 0)
	}
}
