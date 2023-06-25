import UIKit

final class CityTabViewController: UIViewController {
	
	//MARK: - Properties
	
	private var mainDatePlaceList = [Place]()
	private var placeName: String?
	
	//MARK: - Views
	
	private let topEmptyView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .gray
		return view
	}()
	private lazy var datePlaceCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumLineSpacing = 30
		flowLayout.minimumInteritemSpacing = 0
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.backgroundColor = UIColor(named: "bgColor")
		return collectionView
	}()
	private let allContentStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
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
		loadFirebaseData { [weak self] in
			self?.setUpView()
			self?.datePlaceCollectionView.alpha = 0
			self?.datePlaceCollectionView.fadeIn()
			
			NSLayoutConstraint.activate([])
		}
	}
}

private extension CityTabViewController {
	
	//MARK: - Functions
	
	func setUpView() {
		view.addSubview(self.datePlaceCollectionView)
		
		datePlaceCollectionView.dataSource = self
		datePlaceCollectionView.delegate = self
		datePlaceCollectionView.register(
			DatePlaceCollectionViewCell.self,
			forCellWithReuseIdentifier: DatePlaceCollectionViewCell.reuseIdentifier
		)
		
		datePlaceCollectionView.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(0)
		}
	}
	
	func loadFirebaseData(completion: @escaping () -> ()) {
		guard let placeName = placeName else { return }
		let localNameText = "\(placeName)"
		FirebaseService.shared.firestore.collection("\(localNameText)").getDocuments {
			[weak self] (querySnapshot, error) in
			for document in querySnapshot!.documents {
				
				let dto = PlactDTO(
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
				self?.mainDatePlaceList.append(entity)
				DispatchQueue.global().async {
					CacheImageManger().downloadImageAndCache(urlString: entity.imageUrl.first!)
				}
			}
			self?.mainDatePlaceList.shuffle()
			completion()
		}
	}
}

extension CityTabViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return mainDatePlaceList.count
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: DatePlaceCollectionViewCell.reuseIdentifier,
			for: indexPath
		)
		if let cell = cell as? DatePlaceCollectionViewCell {
			cell.datePlaceImageView.image = nil
			cell.datePlaceModel = mainDatePlaceList[indexPath.item]
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let detailDatePlaceViewController = DetailDatePlaceViewController()
		detailDatePlaceViewController.datePlace = mainDatePlaceList[indexPath.item]
		self.navigationController?.pushViewController(detailDatePlaceViewController, animated: true)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let padding: CGFloat = 60
		let collectionViewSize = datePlaceCollectionView.frame.size.width - padding
		return CGSize(width: collectionViewSize/2, height: collectionViewSize / 2 + 90)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
	}
}
