import UIKit
import Tabman
import Pageboy

class TabManViewController: TabmanViewController {
    
    // MARK: Properties
    //
    private var viewControllers: Array<UIViewController> = []
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayoutBar()
    }
    
    // MARK: Functions
    //
    fileprivate func setLayoutBar() {
        // 탭에 커플, 스토리, 기념일 뷰 추가
        //
        let coupleVC = CoupleTabViewController()
        let storyVC = StoryTabViewController()
        //        let anniversaryVC = AnniversaryTabViewController()
        viewControllers.append(coupleVC)
        viewControllers.append(storyVC)
        //        viewControllers.append(anniversaryVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor(named: "bgColor")
        bar.buttons.customize { (button) in
            
            // 선택되지않은 탭 글자 색깔, 선택된 탭 글자 색깔
            //
            button.tintColor = UIColor(white: 0.5, alpha: 0.3)
            button.selectedTintColor = TrendingConstants.appMainColor
            button.font = UIFont(name: "GangwonEduAllBold", size: 20) ?? UIFont.systemFont(ofSize: 20)
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

// MARK: Extension
//
extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        let title: String = index == 0 ? "커플" : index == 1 ? "스토리" : "기념일"
        item.title = title
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
}
