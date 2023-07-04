import Combine
import UIKit

import FirebaseFirestore
import Kingfisher

final class HomeViewController: BaseViewController {
	
	//MARK: - Properties
	
	weak var coordinator: MainViewCoordinator?
	
	private let coupleTabViewModel = CoupleTabViewModel()
	private let mainViewModelCombine = MainViewModelCombine()
	private var disposalbleBag = Set<AnyCancellable>()
	
	//MARK: - Views
	
	private let homeNavigationBarView = HomeNavigationBarView()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		view.addSubview(homeNavigationBarView)
		
		NSLayoutConstraint.activate([
			homeNavigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			homeNavigationBarView.heightAnchor.constraint(equalToConstant: 50),
			homeNavigationBarView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
			homeNavigationBarView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
		])
		
		let homeTabViewController = HomeTabViewController(coupleTabViewModel: coupleTabViewModel)
		addChild(homeTabViewController)
		view.addSubview(homeTabViewController.view)
		
		homeTabViewController.didMove(toParent: self)
		homeTabViewController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			homeTabViewController.view.topAnchor.constraint(equalTo: homeNavigationBarView.bottomAnchor),
			homeTabViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			homeTabViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
			homeTabViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}
	
	override func setupView() {
		view.backgroundColor = UIColor(named: "bgColor")
		
		homeNavigationBarView.delegate = self
		
		mainViewModelCombine.receivedCoupleDayData = coupleTabViewModel.beginCoupleDay.value
		self.mainViewModelCombine.$appNameLabelValue.sink { [weak self] updateLabel in
			DispatchQueue.main.async {
				let transition = CATransition()
				transition.duration = 1
				transition.timingFunction = .init(name: .easeIn)
				transition.type = .fade
				self?.homeNavigationBarView.appNameText.layer.add(transition, forKey: CATransitionType.fade.rawValue)
				self?.homeNavigationBarView.appNameText.text = updateLabel
			}
		}.store(in: &disposalbleBag)
		
		if RealmService.shared.getUserDatas().first!.birthDay != 0 {
			initBirthDayAnniversaryModel(
				dateValue: RealmService.shared.getUserDatas().first!.birthDay
			)
		} else {
			initNotBirthDayAnniversaryModel()
		}
	}
}

extension HomeViewController: HomeNavigationBarDelegate {
	func didSettingBtnTap() {
		coordinator?.showSettingView(coupleTabViewModel: coupleTabViewModel)
	}
	
	func didAnniversaryBtnTap() {
		let anniversaryViewController = AnniversaryViewController()
		anniversaryViewController.modalPresentationStyle = .custom
		anniversaryViewController.transitioningDelegate = self
		coordinator?.showAnniversaryView(vc: anniversaryViewController)
	}
	
	func didPlaceBtnTap() {
		coordinator?.showDatePlaceTabView()
	}
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
	func presentationController (
		forPresented presented: UIViewController,
		presenting: UIViewController?,
		source: UIViewController
	) -> UIPresentationController? {
		PresentationController(presentedViewController: presented, presenting: presenting)
	}
}
