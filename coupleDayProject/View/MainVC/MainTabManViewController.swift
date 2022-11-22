import UIKit

import Pageboy
import Tabman

final class MainTabManViewController: TabmanViewController {
    
    // coupleTabViewModel의 coupleDay data는 coupleTab, StoryTab, 심지어는 SettingView에서도 써야한다.
    // 만약 각 뷰에서 따로 coupleTabViewModel 객체를 새로 만들면 서로 연관이 없는 새로운 뷰모델이 만들어져서 데이터가 공유가 안된다.
    // 따라서 같은 데이터를 공유하려면 이렇게 뷰 모델 자체를 주입시켜서 사용해야한다.
    //
    
    // MARK: Properties
    //
    private var coupleTabViewModel: CoupleTabViewModel?
    private var viewControllers: Array<UIViewController> = []
    
    // MARK: Life Cycle
    //
    init(coupleTabViewModel: CoupleTabViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coupleTabViewModel = coupleTabViewModel
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayoutBar()
    }
    
    // MARK: Functions
    //
    private func setUpLayoutBar() {
        guard let coupleTabViewModel = coupleTabViewModel else { return }
        let coupleVC = CoupleTabViewController(coupleTabViewModel: coupleTabViewModel)
        let storyVC = StoryTabViewController(coupleTabViewModel: coupleTabViewModel)
        viewControllers.append(coupleVC)
        viewControllers.append(storyVC)
        
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

// MARK: Extension
//
extension MainTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        //        let title: String = index == 0 ? "커플" : index == 1 ? "스토리" : "기념일"
        let title: String = index == 0 ? "커플" : "스토리"
        item.title = title
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
}
