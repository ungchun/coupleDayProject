import UIKit

final class PlaceListViewController: BaseViewController {
	
	//MARK: - Properties
	
	private var placeName: String?
	
	//MARK: - Views
	
	private let placeCollectionView = PlaceCollectionView()
	
	//MARK: - Life Cycle
	
	required init(placeName: String) {
		super.init(nibName: nil, bundle: nil)
		self.placeName = placeName
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func setupLayout() {
		view.addSubview(self.placeCollectionView)
		
		NSLayoutConstraint.activate([
			placeCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
			placeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			placeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			placeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
	
	override func setupView() {
		placeCollectionView._delegate = self
		
		Task {
			try await fetchPlace()
			placeCollectionView.reloadData()
			placeCollectionView.alpha = 0
			placeCollectionView.fadeIn()
			NSLayoutConstraint.activate([])
		}
	}
}

private extension PlaceListViewController {
	
	//MARK: - Functions
	
	func fetchPlace() async throws {
		var placeArray: [Place] = []
		guard let placeName = placeName else { return }
		let localNameText = "\(placeName)"
		placeArray = try await FirebaseService.fetchPlace(localNameText: localNameText,
														  fetchKind: .placeList)
		placeCollectionView.mainDatePlaceList.append(contentsOf: placeArray)
		placeCollectionView.mainDatePlaceList.shuffle()
	}
}

extension PlaceListViewController: PlaceCollectionViewDelegate {
	func didPlaceTap(place: Place) {
		let placeInfoViewController = PlaceInfoViewController()
		placeInfoViewController.datePlace = place
		self.navigationController?.pushViewController(placeInfoViewController, animated: true)
	}
}
