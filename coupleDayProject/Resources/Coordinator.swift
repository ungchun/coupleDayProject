import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    
//    func didBeginSet(_ coordinator: BeginViewCoordinator) {
//        print("didBeginSet didBeginSet")
//        self.childCoordinator = self.childCoordinator.filter { $0 !== coordinator }
//        self.showContainerView()
//    }
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let rootViewcontroller = LoadingViewController()
        rootViewcontroller.coordinator = self
        navigationController.pushViewController(rootViewcontroller, animated: false)
    }

    func showBeginView() {
        let child = BeginViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
//        child.delegate = self
        childCoordinator.append(child)
        child.start()
    }
    func showContainerView() {
        print("showContainerView")
        let child = ContainerViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
//        child.delegate = self
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

class BeginViewCoordinator: Coordinator {
    
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
        beginViewController.modalPresentationStyle = .fullScreen
        navigationController.present(beginViewController, animated: false, completion: nil)
    }
    
//    func setBegin() {
//        self.delegate?.didBeginSet(self)
//    }

    func didFinishSecond() {
        parentCoordinator?.childDidFinish(self)
    }
}

class ContainerViewCoordinator: Coordinator {

    weak var parentCoordinator: AppCoordinator?
    private var window: UIWindow?

    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        print("???")
        let containerViewController = ContainerViewController()
        containerViewController.coordinator = self
        containerViewController.modalPresentationStyle = .fullScreen
        navigationController.present(containerViewController, animated: false, completion: nil)
    }
    
    func pushSettingView() {
        print("pushSettingView")
        let child = SettingViewCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start()
    }

    func didFinishSecond() {
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
//    weak var parentCoordinator: ContainerViewCoordinator?
//    private var window: UIWindow?

    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        print("SettingViewCoordinator")
        let settingViewController = SettingViewController()
        settingViewController.coordinator = self
//        settingViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(settingViewController, animated: true)
    }

    func didFinishSecond() {
        parentCoordinator?.childDidFinish(self)
    }
}
