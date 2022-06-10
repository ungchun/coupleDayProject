//
//  MainTabManViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/29.
//

import UIKit
import Tabman
import Pageboy

class TabManViewController: TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []
    
    // MARK: func
    fileprivate func layoutBar() {
        let coupleVC = CoupleTabViewController() // 커플
        let storyVC = StoryTabViewController() // 스토리
        let anniversaryVC = AnniversaryTabViewController() // 기념일
        
        viewControllers.append(coupleVC)
        viewControllers.append(storyVC)
        viewControllers.append(anniversaryVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.buttons.customize { (button) in
            button.tintColor = .black // 현재 선택되지않은 탭 글자 컬러
            button.selectedTintColor = TrendingConstants.appMainColor // 현재 선택된 탭 글자 컬러
//            button.font = UIFont(name: "JejuMyeongjoOTF", size: 14) ?? UIFont.systemFont(ofSize: 14)
        }
        bar.layout.transitionStyle = .snap
        bar.layout.interButtonSpacing = 20
        bar.indicator.weight = .custom(value: 2.5) // 얘 없어도 될거 같은데 나중에 두개 비교해보기 (없애려면 value = 0)
        bar.indicator.tintColor = TrendingConstants.appMainColor
        bar.layout.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        bar.indicator.overscrollBehavior = .bounce
        addBar(bar, dataSource: self, at: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutBar()
    }
}

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
