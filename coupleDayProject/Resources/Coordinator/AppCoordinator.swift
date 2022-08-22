import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

// AppCoordinator 자식 -> Container(Main), Begin 으로 이동 가능
//
class AppCoordinator: Coordinator, BeginViewCoordinatorDelegate {
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // BeginViewCoordinator로 부터 응답을 받으면 ContainerView로 이동
    //
    func didBeginSet(_ coordinator: BeginViewCoordinator) {
        self.childCoordinator = self.childCoordinator.filter { $0 !== coordinator }
        self.showContainerView()
    }
    
    func start() {
        let rootViewcontroller = LoadingViewController()
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
    func showContainerView() {
        let child = ContainerViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start()
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

class BeginViewCoordinator: Coordinator, BeginViewControllerDelegate {
    
    var delegate: BeginViewCoordinatorDelegate?
    
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // AppCoordinator에 ContainerView로 이동하자고 알림
    //
    func setBegin() {
        self.delegate?.didBeginSet(self)
    }
    
    func start() {
        let beginViewController = BeginViewController()
        beginViewController.coordinator = self
        beginViewController.delegate = self
        self.navigationController.viewControllers = [beginViewController]
    }
    
    func didFinishBeginView() {
        parentCoordinator?.childDidFinish(self)
    }
}

// AppCoordinator의 자식이면서 SettingViewCoordinator의 부모
//
class ContainerViewCoordinator: Coordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let containerViewController = ContainerViewController()
        containerViewController.coordinator = self
        self.navigationController.viewControllers = [containerViewController]
    }
    
    func showSettingView() {
        let child = SettingViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start()
    }
    func showAnniversaryView(vc: AnniversaryViewController) {
        let child = AnniversaryCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start(vc: vc)
    }
    
    func didFinishContainerView() {
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

class SettingViewCoordinator: Coordinator {
    
    weak var parentCoordinator: ContainerViewCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingViewController = SettingViewController()
        settingViewController.coordinator = self
        navigationController.pushViewController(settingViewController, animated: true)
    }
    
    func didFinishSettingView() {
        parentCoordinator?.childDidFinish(self)
    }
}

class AnniversaryCoordinator: Coordinator {
    
    weak var parentCoordinator: ContainerViewCoordinator?
    
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
