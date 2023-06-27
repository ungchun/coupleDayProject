import UIKit

protocol SetupViewControllerDelegate: AnyObject {
	func showHomeView()
}

final class SetupViewController: BaseViewController {
	
	//MARK: - Properties
	
	weak var coordinator: SetupViewCoordinator?
	weak var delegate: SetupViewControllerDelegate?
	
	//MARK: - Views
	
	private let _setupView = SetupView()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		coordinator?.didFinishSetup()
	}
	
	override func setupLayout() {
		view.addSubview(_setupView)
		
		NSLayoutConstraint.activate([
			_setupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			_setupView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	override func setupView() {
		view.backgroundColor = TrendingConstants.appMainColorAlaph40
		
		_setupView.delegate = self
	}
}

extension SetupViewController: SetupViewDelegate {
	func didStartBtnTap() {
		self.delegate?.showHomeView()
	}
}
