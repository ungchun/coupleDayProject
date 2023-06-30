import UIKit

import Pageboy
import Tabman

final class PlaceListTabViewController: TabmanViewController {
	
	//MARK: - Properties
	
	private var tabTitleArray: Array<String> = ["서울", "수도권", "충청", "강원", "경상", "전라", "제주"]
	private var viewControllers: Array<UIViewController> = []
	weak var coordinator: DatePlaceTabViewCoordinator?
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupBackBtn()
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.isNavigationBarHidden = false
		self.navigationItem.title = ""
		
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(named: "bgColor")
		appearance.shadowColor = .clear
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = true
		navigationController?.navigationBar.scrollEdgeAppearance = .none
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		coordinator?.didFinishAnniversaryView()
	}
}

private extension PlaceListTabViewController {
	
	//MARK: - Functions
	
	func setupBackBtn() {
		self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
		UIBarButtonItem.appearance().setTitleTextAttributes([
			NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any
		], for: .normal)
		self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
		self.view.backgroundColor = UIColor(named: "bgColor")
	}
	
	func setupLayout() {
		let seoul = PlaceListViewController(placeName: "seoul")
		viewControllers.append(seoul)
		let sudo = PlaceListViewController(placeName: "sudo")
		viewControllers.append(sudo)
		let chungcheong = PlaceListViewController(placeName: "chungcheong")
		viewControllers.append(chungcheong)
		let gangwon = PlaceListViewController(placeName: "gangwon")
		viewControllers.append(gangwon)
		let gyeongsang = PlaceListViewController(placeName: "gyeongsang")
		viewControllers.append(gyeongsang)
		let jeolla = PlaceListViewController(placeName: "jeolla")
		viewControllers.append(jeolla)
		let jeju = PlaceListViewController(placeName: "jeju")
		viewControllers.append(jeju)
		
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
		bar.scrollMode = .interactive
		bar.layout.transitionStyle = .snap
		bar.layout.interButtonSpacing = 30
		bar.indicator.weight = .custom(value: 2.5)
		bar.indicator.tintColor = TrendingConstants.appMainColor
		bar.layout.contentInset = UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30)
		bar.indicator.overscrollBehavior = .bounce
		addBar(bar, dataSource: self, at: .top)
	}
}

extension PlaceListTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
	func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
		let item = TMBarItem(title: "")
		let title: String = tabTitleArray[index]
		item.title = title
		return item
	}
	
	func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
		return viewControllers.count
	}
	
	func viewController(
		for pageboyViewController: Pageboy.PageboyViewController,
		at index: Pageboy.PageboyViewController.PageIndex
	) -> UIViewController? {
		return viewControllers[index]
	}
	
	func defaultPage(
		for pageboyViewController: Pageboy.PageboyViewController
	) -> Pageboy.PageboyViewController.Page? {
		return .at(index: 0)
	}
}
