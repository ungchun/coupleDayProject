import UIKit

//MARK: - Protocol

protocol Coordinator: AnyObject {
	var childCoordinator: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }
	
	func start()
}
protocol AppCoordinatorting: Coordinator {
	func showSetupView()
	func showHomeView()
}
protocol SetupCoordinatorting: Coordinator {}
protocol HomeCoordinatorting: Coordinator {
	func showSettingView(coupleTabViewModel: CoupleTabViewModel)
	func showAnniversaryView(vc: AnniversaryViewController)
}
protocol SettingCoordinatorting: Coordinator {}
protocol AnniversaryCoordinatorting: Coordinator {}
protocol DatePlaceTabCoordinatorting: Coordinator {}

/// AppCoordinator의 자식 -> Home, Setup 으로 이동 가능
final class AppCoordinator: AppCoordinatorting, SetupViewCoordinatorDelegate {
	
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
	
	func showSetupView() {
		let child = SetupViewCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		child.delegate = self
		childCoordinator.append(child)
		child.start()
	}
	
	func showHomeView() {
		let child = MainViewCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		childCoordinator.append(child)
		child.start()
	}
	
	/// SetupViewCoordinator로 부터 응답을 받으면 HomeView로 이동
	func didSetup(_ coordinator: SetupViewCoordinator) {
		self.childCoordinator = self.childCoordinator.filter { $0 !== coordinator }
		self.showHomeView()
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

protocol SetupViewCoordinatorDelegate {
	func didSetup(_ coordinator: SetupViewCoordinator)
}

final class SetupViewCoordinator: SetupCoordinatorting, SetupViewControllerDelegate {
	
	var delegate: SetupViewCoordinatorDelegate?
	
	weak var parentCoordinator: AppCoordinator?
	
	var childCoordinator = [Coordinator]()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let setupViewController = SetupViewController()
		setupViewController.coordinator = self
		setupViewController.delegate = self
		self.navigationController.viewControllers = [setupViewController]
	}
	
	/// AppCoordinator(부모)에 MainView로 이동하라고 알림
	func showHomeView() {
		self.delegate?.didSetup(self)
	}
	
	func didFinishSetup() {
		parentCoordinator?.childDidFinish(self)
	}
}

/// AppCoordinator의 자식이면서 SettingViewCoordinator의 부모
final class MainViewCoordinator: HomeCoordinatorting {
	
	weak var parentCoordinator: AppCoordinator?
	
	var childCoordinator = [Coordinator]()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let mainViewController = HomeViewController()
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
	
	func showDatePlaceTabView() {
		let child = DatePlaceTabViewCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		childCoordinator.append(child)
		child.start()
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

final class DatePlaceTabViewCoordinator: DatePlaceTabCoordinatorting {
	
	weak var parentCoordinator: MainViewCoordinator?
	
	var childCoordinator = [Coordinator]()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let placeListTabViewController = PlaceListTabViewController()
		placeListTabViewController.coordinator = self
		self.navigationController.pushViewController(placeListTabViewController, animated: true)
	}
	
	func didFinishAnniversaryView() {
		parentCoordinator?.childDidFinish(self)
	}
}
