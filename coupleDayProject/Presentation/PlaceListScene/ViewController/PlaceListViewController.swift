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
		
		placeCollectionView.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(0)
		}
	}
	
	override func setupView() {
		placeCollectionView._delegate = self
		
		loadFirebaseData { [weak self] in
			self?.placeCollectionView.reloadData()
			self?.placeCollectionView.alpha = 0
			self?.placeCollectionView.fadeIn()
			NSLayoutConstraint.activate([])
		}
	}
}

private extension PlaceListViewController {
	
	//MARK: - Functions
	
	func loadFirebaseData(completion: @escaping () -> ()) {
		guard let placeName = placeName else { return }
		let localNameText = "\(placeName)"
		FirebaseService.shared.firestore.collection("\(localNameText)").getDocuments {
			[weak self] (querySnapshot, error) in
			for document in querySnapshot!.documents {
				let dto = PlaceDTO(
					id: document.documentID,
					modifyState: document.data()["modifyState"] as? Bool,
					address: document.data()["address"] as? String,
					shortAddress: document.data()["shortAddress"] as? String,
					introduce: document.data()["introduce"] as? [String],
					imageUrl: document.data()["imageUrl"] as? [String],
					latitude: document.data()["latitude"] as? String,
					longitude: document.data()["longitude"] as? String
				)
				let entity = dto.toEntity()
				self?.placeCollectionView.mainDatePlaceList.append(entity)
				DispatchQueue.global().async {
					CacheImageManger().downloadImageAndCache(urlString: entity.imageUrl.first!)
				}
			}
			self?.placeCollectionView.mainDatePlaceList.shuffle()
			completion()
		}
	}
}

extension PlaceListViewController: PlaceCollectionViewDelegate {
	func didPlaceTap(place: Place) {
		let detailDatePlaceViewController = DetailDatePlaceViewController()
		detailDatePlaceViewController.datePlace = place
		self.navigationController?.pushViewController(detailDatePlaceViewController, animated: true)
	}
}
