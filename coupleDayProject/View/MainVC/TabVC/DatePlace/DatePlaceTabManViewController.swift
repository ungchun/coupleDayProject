import UIKit
import Tabman
import Pageboy

final class DatePlaceTabManViewController: TabmanViewController {

    // MARK: Properties
    //
    private var tabTitleArray: Array<String> = ["서울", "수도권", "충청", "강원", "경상", "전라", "제주"]
    private var viewControllers: Array<UIViewController> = []
    weak var coordinator: DatePlaceTabViewCoordinator?
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 상단 NavigationBar 공간 show (뒤로가기 버튼)
        //
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackBtn()
        setUpLayoutBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishAnniversaryView()
    }
    
    // MARK: Functions
    //
    private func setUpBackBtn() {
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
    }
    private func setUpLayoutBar() {
        
        let seoulVC = SeoulViewController()
        viewControllers.append(seoulVC)
        let sudoVC = SudoViewController()
        viewControllers.append(sudoVC)
        let chungcheongVC = ChungcheongViewController()
        viewControllers.append(chungcheongVC)
        let gangwonVC = GangwonViewController()
        viewControllers.append(gangwonVC)
        let gyeongsangVC = GyeongsangViewController()
        viewControllers.append(gyeongsangVC)
        let jeollaVC = JeollaViewController()
        viewControllers.append(jeollaVC)
        let jejuVC = JejuViewController()
        viewControllers.append(jejuVC)
        
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor(named: "bgColor")
        bar.buttons.customize { (button) in
            button.tintColor = UIColor(white: 0.5, alpha: 0.3)
            button.selectedTintColor = TrendingConstants.appMainColor
            button.font = UIFont(name: "GangwonEduAllBold", size: 20) ?? UIFont.systemFont(ofSize: 20)
        }
        bar.scrollMode = .swipe
        bar.layout.transitionStyle = .snap
        bar.layout.interButtonSpacing = 30
        bar.indicator.weight = .custom(value: 2.5)
        bar.indicator.tintColor = TrendingConstants.appMainColor
        bar.layout.contentInset = UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30)
        bar.indicator.overscrollBehavior = .bounce
        addBar(bar, dataSource: self, at: .top)
    }
}

extension DatePlaceTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        let title: String = tabTitleArray[index]
        item.title = title
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
}
