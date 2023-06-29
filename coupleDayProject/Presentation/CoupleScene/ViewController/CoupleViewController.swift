import Photos
import UIKit
import WatchConnectivity

import CropViewController
import GoogleMobileAds
import Kingfisher
import TOCropViewController

final class CoupleViewController: BaseViewController {
	
	//MARK: - Properties
	
	private var coupleTabViewModel: CoupleTabViewModel?
	
	private var mainDatePlaceList = [Place]()
	private let imagePickerController = UIImagePickerController()
	private var whoProfileChangeCheck = "my"
	
	private let mainImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium)
	private let myProfileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium)
	private let profileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium)
	
	private var loadingCheck = false
	
	//MARK: - Views
	
	private let allContentStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.translatesAutoresizingMaskIntoConstraints = false
		view.distribution = .fill
		return view
	}()
	
	private let topTabBackView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .red
		return view
	}()
	
//	private let mainImageView: UIImageView = {
//		let view = UIImageView()
//		view.translatesAutoresizingMaskIntoConstraints = false
//		return view
//	}()
	private let coupleBackgroundImageView = CoupleBackgroundImageView()
	
//	private let bottomEmptyView: UIView = {
//		let view = UIView()
//		view.translatesAutoresizingMaskIntoConstraints = false
//		view.backgroundColor = .blue
//		return view
//	}()
	
	private let profileImageDayStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.alignment = .center
		view.distribution = .equalSpacing
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	private let myProfileUIImageView: UIImageView = {
		let view = UIImageView()
		return view
	}()
	private let partnerProfileUIImageView: UIImageView = {
		let view = UIImageView()
		return view
	}()
	private let loveIconDayStackView: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.alignment = .center
		view.spacing = 5
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	private let loveIconView: UIImageView = {
		let view = UIImageView()
		view.image = UIImage(
			systemName: "heart.fill",
			withConfiguration: UIImage.SymbolConfiguration(
				pointSize: 24,
				weight: UIImage.SymbolWeight.light
			)
		)
		view.tintColor = TrendingConstants.appMainColor
		return view
	}()
	private let dayText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = ""
		label.font = UIFont(name: "GangwonEduAllLight", size: 25)
		return label
	}()
	
	
	private lazy var datePlaceTitle: UILabel = {
		var label = UILabel()
		label.font = UIFont(name: "GangwonEduAllBold", size: CommonSize.coupleTextBigSize)
		return label
	}()
	private lazy var datePlaceCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = UIColor(named: "bgColor")
		return collectionView
	}()
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = false
		activityIndicator.style = UIActivityIndicatorView.Style.medium
		activityIndicator.startAnimating()
		return activityIndicator
	}()
	private lazy var DatePlaceStackView: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [datePlaceTitle, datePlaceCollectionView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.backgroundColor = UIColor(named: "bgColor")
		return stackView
	}()
	
	//MARK: - Life Cycle
	
	init(coupleTabViewModel: CoupleTabViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.coupleTabViewModel = coupleTabViewModel
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(changeDarkModeSet(notification:)),
			name: Notification.Name.darkModeCheck,
			object: nil
		)
		
		loadFirebaseData { [weak self] in
			guard let activityIndicator = self?.activityIndicator else { return }
			guard let datePlaceStackView = self?.DatePlaceStackView else { return }
			self?.allContentStackView.removeArrangedSubview(activityIndicator)
			self?.allContentStackView.addArrangedSubview(datePlaceStackView)
			
			self?.DatePlaceStackView.alpha = 0
			self?.DatePlaceStackView.fadeIn()
			
			NSLayoutConstraint.activate([
				datePlaceStackView.leftAnchor.constraint(
					equalTo: (self?.view.safeAreaLayoutGuide.leftAnchor)!,
					constant: 20
				),
				datePlaceStackView.rightAnchor.constraint(
					equalTo: (self?.view.safeAreaLayoutGuide.rightAnchor)!,
					constant: -20
				),
			])
		}
		
		datePlaceCollectionView.dataSource = self
		datePlaceCollectionView.delegate = self
		datePlaceCollectionView.register(
			TodayDatePlaceCollectionViewCell.self,
			forCellWithReuseIdentifier: "cell"
		)
		
		imagePickerController.delegate = self
		
		beforeImageLoadingView()
		coupleTabViewModelBinding()
	}
}

private extension CoupleViewController {
	
	//MARK: - Functions
	
	func loadFirebaseData(completion: @escaping () -> ()) {
		var count = 0
		guard let localNameText = LocalName.randomElement()?.key else { return }
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
				guard let localName = LocalName[localNameText] else { return }
				self?.datePlaceTitle.text = "\(localName)의 오늘 장소"
				self?.mainDatePlaceList.append(entity)
				count += 1
				
				DispatchQueue.global().async {
					CacheImageManger().downloadImageAndCache(urlString: entity.imageUrl.first!)
				}
				
				if count == 5 { break }
			}
			self?.mainDatePlaceList.shuffle()
			completion()
		}
	}
	
	func coupleTabViewModelBinding() {
		guard let coupleTabViewModel = coupleTabViewModel else { return }
		
		coupleTabViewModel.beginCoupleDay.bind { [weak self] beginCoupleDay in
			DispatchQueue.main.async {
				self?.dayText.text = beginCoupleDay
			}
			let dayData: [String: Any] = [
				"dayData":
					String(describing: RealmService.shared.getUserDatas().first!.beginCoupleDay)
			]
			try? WCSession.default.updateApplicationContext(dayData)
		}
		
		coupleTabViewModel.homeMainImageData.bind { [weak self] imageData in
			DispatchQueue.main.async {
				self?.coupleBackgroundImageView.backgroundImageView.image = UIImage(data: imageData)
				guard let loadingCheck = self?.loadingCheck else { return }
				if !loadingCheck {
					self?.afterImageLoadingView()
					self?.loadingCheck = true
				}
				guard let data = UIImage(data: coupleTabViewModel.homeMainImageData.value)?.jpegData(compressionQuality: 0.1) else { return }
				let imageData: [String: Any] = ["imageData": data]
				WCSession.default.transferUserInfo(imageData)
			}
		}
		
		coupleTabViewModel.myProfileImageData.bind({ [weak self] imageData in
			DispatchQueue.main.async {
				self?.myProfileUIImageView.image = UIImage(data: imageData)
			}
		})
		
		coupleTabViewModel.partnerProfileImageData.bind({ [weak self] imageData in
			DispatchQueue.main.async {
				self?.partnerProfileUIImageView.image = UIImage(data: imageData)
			}
		})
	}
	
	func beforeImageLoadingView() {
		view.backgroundColor = UIColor(named: "bgColor")
		mainImageActivityIndicatorView.startAnimating()
		mainImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		myProfileImageActivityIndicatorView.startAnimating()
		myProfileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		profileImageActivityIndicatorView.startAnimating()
		profileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		
		setUpView(imageLoadingFlag: false)
	}
	
	func afterImageLoadingView() {
		view.backgroundColor = UIColor(named: "bgColor")
		profileImageActivityIndicatorView.stopAnimating()
		myProfileImageActivityIndicatorView.stopAnimating()
		mainImageActivityIndicatorView.stopAnimating()
		
		setUpView(imageLoadingFlag: true)
	}
	
	func setUpView(imageLoadingFlag: Bool) {
		let tapGestureMyProfileUIImageView = UITapGestureRecognizer(
			target: self,
			action: #selector(myProfileTap(_:))
		)
		myProfileUIImageView.addGestureRecognizer(tapGestureMyProfileUIImageView)
		myProfileUIImageView.isUserInteractionEnabled = true
		myProfileUIImageView.layer.cornerRadius = CommonSize.coupleProfileSize / 2
		myProfileUIImageView.clipsToBounds = true
		
		let tapGesturePartnerProfileUIImageView = UITapGestureRecognizer(
			target: self,
			action: #selector(partnerProfileTap(_:))
		)
		partnerProfileUIImageView.isUserInteractionEnabled = true
		partnerProfileUIImageView.addGestureRecognizer(tapGesturePartnerProfileUIImageView)
		partnerProfileUIImageView.layer.cornerRadius = CommonSize.coupleProfileSize / 2
		partnerProfileUIImageView.clipsToBounds = true
		
		let imagePartView = imageLoadingFlag ? self.coupleBackgroundImageView.backgroundImageView : self.mainImageActivityIndicatorView
		
		view.addSubview(allContentStackView)
		allContentStackView.addArrangedSubview(topTabBackView)
		allContentStackView.addArrangedSubview(imagePartView)
		allContentStackView.addArrangedSubview(profileImageDayStackView)
		allContentStackView.addArrangedSubview(activityIndicator)
		
		profileImageDayStackView.addArrangedSubview(myProfileUIImageView)
		profileImageDayStackView.addArrangedSubview(loveIconDayStackView)
		profileImageDayStackView.addArrangedSubview(partnerProfileUIImageView)
		
		loveIconDayStackView.addArrangedSubview(loveIconView)
		loveIconDayStackView.addArrangedSubview(dayText)
		
		allContentStackView.setCustomSpacing(15, after: imagePartView)
		allContentStackView.setCustomSpacing(10, after: profileImageDayStackView)
		
		NSLayoutConstraint.activate([
			myProfileUIImageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
			myProfileUIImageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
			
			partnerProfileUIImageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
			partnerProfileUIImageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
			
			loveIconView.widthAnchor.constraint(equalToConstant: 30),
			loveIconView.heightAnchor.constraint(equalToConstant: 30),
			
			topTabBackView.topAnchor.constraint(equalTo: view.topAnchor),
			topTabBackView.heightAnchor.constraint(equalToConstant: 80),
			
			imagePartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3),
			imagePartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			imagePartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
			
			profileImageDayStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 45),
			profileImageDayStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -45),
			profileImageDayStackView.heightAnchor.constraint(equalToConstant: CommonSize.coupleStackViewHeightSize),
			
			allContentStackView.topAnchor.constraint(equalTo: view.topAnchor),
			allContentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			allContentStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
			allContentStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}
	
	@objc func myProfileTap(_ gesture: UITapGestureRecognizer) {
		whoProfileChangeCheck = "my"
		self.present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
		whoProfileChangeCheck = "partner"
		self.present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc func changeDarkModeSet(notification: Notification) {
		coupleTabViewModel?.updateMyProfileIcon()
		coupleTabViewModel?.updatePartnerProfileIcon()
	}
}

extension CoupleViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		let imageData = info[.editedImage] is UIImage ? info[.editedImage] : info[.originalImage]
		dismiss(animated: true) { [weak self] in
			self?.presentCropViewController(image: imageData as! UIImage)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}

extension CoupleViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return 5
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		if self.mainDatePlaceList.count > indexPath.item {
			if let cell = cell as? TodayDatePlaceCollectionViewCell {
				cell.datePlaceImageView.image = nil
				cell.datePlaceModel = mainDatePlaceList[indexPath.item]
			}
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
		return CGSize(
			width: CommonSize.coupleCellImageSize + 10,
			height: datePlaceCollectionView.frame.height
		)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
}

extension CoupleViewController: UICollectionViewDelegate {}

extension CoupleViewController: CropViewControllerDelegate {
	func presentCropViewController(image: UIImage) {
		let image: UIImage = image
		let cropViewController = CropViewController(croppingStyle: .circular, image: image)
		cropViewController.delegate = self
		cropViewController.aspectRatioLockEnabled = true
		cropViewController.aspectRatioPickerButtonHidden = true
		cropViewController.doneButtonTitle = "완료"
		cropViewController.cancelButtonTitle = "취소"
		present(cropViewController, animated: true, completion: nil)
	}
	
	func cropViewController(
		_ cropViewController: CropViewController,
		didCropToImage image: UIImage,
		withRect cropRect: CGRect, angle: Int
	) {
		guard let coupleTabViewModel = coupleTabViewModel else { return }
		if whoProfileChangeCheck == "my" {
			RealmService.shared.updateMyProfileImage(myProfileImage: image)
			coupleTabViewModel.updateMyProfileIcon()
		} else {
			RealmService.shared.updatePartnerProfileImage(partnerProfileImage: image)
			coupleTabViewModel.updatePartnerProfileIcon()
		}
		dismiss(animated: true, completion: nil)
	}
}

extension CoupleViewController : GADBannerViewDelegate {
	public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		bannerView.alpha = 0
		UIView.animate(withDuration: 1) {
			bannerView.alpha = 1
		}
	}
}
