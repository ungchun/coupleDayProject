import UIKit

final class AnniversaryViewController: BaseViewController {
	
	//MARK: - Properties
	
	weak var coordinator: AnniversaryViewCoordinator?
	
	//MARK: - Views
	
	private let anniversaryTitleView = AnniversaryTitleView()
	private let anniversaryTableView = AnniversaryTableView()
	
	private let divider: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .systemGray5
		return view
	}()
	
	private let contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 5
		return stackView
	}()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		DispatchQueue.main.async {
			self.anniversaryTableView.reloadData()
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		coordinator?.didFinishAnniversaryView()
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		view.addSubview(contentView)
		contentView.addArrangedSubview(anniversaryTitleView)
		contentView.addArrangedSubview(divider)
		contentView.addArrangedSubview(anniversaryTableView)
		
		NSLayoutConstraint.activate([
			divider.heightAnchor.constraint(equalToConstant: 1),
			
			anniversaryTitleView.heightAnchor.constraint(equalToConstant: 50),
			
			contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5),
			contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//			contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
	}
	
	override func setupView() {
		view.backgroundColor = UIColor(named: "bgColor")
	}
}
