import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator, BeginViewCoordinatorDelegate {
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func didBeginSet(_ coordinator: BeginViewCoordinator) {
        print("didBeginSet")
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
    
    func setBegin() {
        self.delegate?.didBeginSet(self)
    }
    
    var delegate: BeginViewCoordinatorDelegate?
    
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
