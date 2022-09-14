import Foundation
import UIKit

// MARK: Protocol
//
protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
protocol AppCoordinatorting: Coordinator {
    func showBeginView()
    func showMainView()
}
protocol BeginCoordinatorting: Coordinator {}
protocol ContainerCoordinatorting: Coordinator {
    func showSettingView(coupleTabViewModel: CoupleTabViewModel)
    func showAnniversaryView(vc: AnniversaryViewController)
}
protocol SettingCoordinatorting: Coordinator {}
protocol AnniversaryCoordinatorting: Coordinator {}
protocol DatePlaceCoordinatorting: Coordinator {}

// AppCoordinator의 자식 -> Container(Main), Begin 으로 이동 가능
//
final class AppCoordinator: AppCoordinatorting, BeginViewCoordinatorDelegate {
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let rootViewcontroller = AppLoadingViewController()
        rootViewcontroller.coordinator = self
        navigationController.pushViewController(rootViewcontroller, animated: false)
    }
    
    func showBeginView() {
        let child = BeginViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        child.delegate = self
        childCoordinator.append(child)
        child.start()
    }
    func showMainView() {
        let child = MainViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start()
    }
    
    // BeginViewCoordinator로 부터 응답을 받으면 MainView로 이동
    //
    func didBeginSet(_ coordinator: BeginViewCoordinator) {
        self.childCoordinator = self.childCoordinator.filter { $0 !== coordinator }
        self.showMainView()
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
}

protocol BeginViewCoordinatorDelegate {
    func didBeginSet(_ coordinator: BeginViewCoordinator)
}
final class BeginViewCoordinator: BeginCoordinatorting, SetBeginDayViewControllerDelegate {
    
    var delegate: BeginViewCoordinatorDelegate?
    
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let beginViewController = SetBeginDayViewController()
        beginViewController.coordinator = self
        beginViewController.delegate = self
        self.navigationController.viewControllers = [beginViewController]
    }
    
    // AppCoordinator(부모)에 MainView로 이동하라고 알림
    //
    func setBegin() {
        self.delegate?.didBeginSet(self)
    }
    
    func didFinishBeginView() {
        parentCoordinator?.childDidFinish(self)
    }
}

// AppCoordinator의 자식이면서 SettingViewCoordinator의 부모
//
final class MainViewCoordinator: ContainerCoordinatorting {
    
    weak var parentCoordinator: AppCoordinator?
        
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        self.navigationController.viewControllers = [mainViewController]
    }
    
    func showSettingView(coupleTabViewModel: CoupleTabViewModel) {
        let child = SettingViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start(coupleTabViewModel: coupleTabViewModel)
    }
    func showAnniversaryView(vc: AnniversaryViewController) {
        let child = AnniversaryViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start(vc: vc)
    }

    func didFinishMainView() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
}

final class SettingViewCoordinator: SettingCoordinatorting {
    
    weak var parentCoordinator: MainViewCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {}
    func start(coupleTabViewModel: CoupleTabViewModel) {
        let settingViewController = SettingViewController(coupleTabViewModel: coupleTabViewModel)
        settingViewController.coordinator = self
        navigationController.pushViewController(settingViewController, animated: true)
    }
    
    func didFinishSettingView() {
        parentCoordinator?.childDidFinish(self)
    }
}

final class AnniversaryViewCoordinator: AnniversaryCoordinatorting {
    
    weak var parentCoordinator: MainViewCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {}
    func start(vc: AnniversaryViewController) {
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    func didFinishAnniversaryView() {
        parentCoordinator?.childDidFinish(self)
    }
}
