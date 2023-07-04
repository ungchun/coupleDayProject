import Photos
import UIKit
import WatchConnectivity

import CropViewController
import Kingfisher
import TOCropViewController

final class CoupleViewController: BaseViewController {
	
	//MARK: - Properties
	
	private var coupleTabViewModel: CoupleTabViewModel?
	private let imagePickerController = UIImagePickerController()
	private var whoProfileChangeCheck = "my"
	private var loadingCheck = false
	
	//MARK: - Views
	
	private let backgroundImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium)
	private let myProfileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium)
	private let profileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium)
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = false
		activityIndicator.style = UIActivityIndicatorView.Style.medium
		activityIndicator.startAnimating()
		return activityIndicator
	}()
	
	private let coupleBackgroundImageView = CoupleBackgroundImageView()
	private let coupleProfileImageAndDayView = CoupleProfileImageAndDayView()
	private let coupleTodayPlaceView = CoupleTodayPlaceView()
	
	private let topEmptyView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let contentView: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.translatesAutoresizingMaskIntoConstraints = false
		view.distribution = .fill
		return view
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
			guard let coupleTodayPlaceView = self?.coupleTodayPlaceView else { return }
			self?.contentView.removeArrangedSubview(activityIndicator)
			self?.contentView.addArrangedSubview(coupleTodayPlaceView)
			
			self?.coupleTodayPlaceView.alpha = 0
			self?.coupleTodayPlaceView.fadeIn()
			
			NSLayoutConstraint.activate([
				coupleTodayPlaceView.leftAnchor.constraint(
					equalTo: (self?.view.safeAreaLayoutGuide.leftAnchor)!,
					constant: 20
				),
				coupleTodayPlaceView.rightAnchor.constraint(
					equalTo: (self?.view.safeAreaLayoutGuide.rightAnchor)!,
					constant: -20
				),
			])
		}
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		beforeImageLoadingView()
	}
	
	override func setupView() {
		imagePickerController.delegate = self
		coupleProfileImageAndDayView.delegate = self
		coupleTabViewModelBinding()
	}
}

private extension CoupleViewController {
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
				self?.coupleTodayPlaceView.todayPlaceText.text = "\(localName)의 오늘 장소"
				self?.coupleTodayPlaceView.mainDatePlaceList.append(entity)
				count += 1
				
				DispatchQueue.global().async {
					CacheImageManger().downloadImageAndCache(urlString: entity.imageUrl.first!)
				}
				
				if count == 5 { break }
			}
			self?.coupleTodayPlaceView.mainDatePlaceList.shuffle()
			completion()
		}
	}
	
	func coupleTabViewModelBinding() {
		guard let coupleTabViewModel = coupleTabViewModel else { return }
		
		coupleTabViewModel.beginCoupleDay.bind { [weak self] beginCoupleDay in
			DispatchQueue.main.async {
				self?.coupleProfileImageAndDayView.dayText.text = beginCoupleDay
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
				self?.coupleProfileImageAndDayView.myProfileImageView.image = UIImage(data: imageData)
			}
		})
		
		coupleTabViewModel.partnerProfileImageData.bind({ [weak self] imageData in
			DispatchQueue.main.async {
				self?.coupleProfileImageAndDayView.partnerProfileImageView.image = UIImage(data: imageData)
			}
		})
	}
	
	func beforeImageLoadingView() {
		view.backgroundColor = UIColor(named: "bgColor")
		backgroundImageActivityIndicatorView.startAnimating()
		backgroundImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		myProfileImageActivityIndicatorView.startAnimating()
		myProfileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		profileImageActivityIndicatorView.startAnimating()
		profileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		
		setupLayout(imageLoadingFlag: false)
	}
	
	func afterImageLoadingView() {
		view.backgroundColor = UIColor(named: "bgColor")
		profileImageActivityIndicatorView.stopAnimating()
		myProfileImageActivityIndicatorView.stopAnimating()
		backgroundImageActivityIndicatorView.stopAnimating()
		
		setupLayout(imageLoadingFlag: true)
	}
	
	func setupLayout(imageLoadingFlag: Bool) {
		let imagePartView = imageLoadingFlag ? self.coupleBackgroundImageView.backgroundImageView : self.backgroundImageActivityIndicatorView
		
		view.addSubview(contentView)
		contentView.addArrangedSubview(topEmptyView)
		contentView.addArrangedSubview(imagePartView)
		contentView.addArrangedSubview(coupleProfileImageAndDayView)
		contentView.addArrangedSubview(activityIndicator)
		
		contentView.setCustomSpacing(15, after: imagePartView)
		contentView.setCustomSpacing(10, after: coupleProfileImageAndDayView)
		
		NSLayoutConstraint.activate([
			topEmptyView.topAnchor.constraint(equalTo: view.topAnchor),
			topEmptyView.heightAnchor.constraint(equalToConstant: 80),
			
			imagePartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3),
			imagePartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			imagePartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
			
			coupleProfileImageAndDayView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 45),
			coupleProfileImageAndDayView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -45),
			coupleProfileImageAndDayView.heightAnchor.constraint(equalToConstant: CommonSize.coupleStackViewHeightSize),
			
			contentView.topAnchor.constraint(equalTo: view.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
			contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}
	
	@objc func changeDarkModeSet(notification: Notification) {
		coupleTabViewModel?.updateMyProfileIcon()
		coupleTabViewModel?.updatePartnerProfileIcon()
	}
}

extension CoupleViewController: CoupleProfileImageAndDayViewDelegate {
	func didMyProfileTap() {
		whoProfileChangeCheck = "my"
		self.present(imagePickerController, animated: true, completion: nil)
	}
	
	func didPartnerProfileTap() {
		whoProfileChangeCheck = "partner"
		self.present(imagePickerController, animated: true, completion: nil)
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
