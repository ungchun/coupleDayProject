import Photos
import UIKit
import WatchConnectivity

import RxSwift
import RxCocoa
import CropViewController
import Kingfisher
import TOCropViewController

final class CoupleViewController: BaseViewController {
	
	//MARK: - Properties
	
	private let disposeBag = DisposeBag()
	
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
		
		Task {
			try await fetchPlace()
			
			self.coupleTodayPlaceView.alpha = 0
			self.coupleTodayPlaceView.fadeIn()
			
			NSLayoutConstraint.activate([
				coupleTodayPlaceView.leftAnchor.constraint(
					equalTo: (self.view.safeAreaLayoutGuide.leftAnchor),
					constant: 20
				),
				coupleTodayPlaceView.rightAnchor.constraint(
					equalTo: (self.view.safeAreaLayoutGuide.rightAnchor),
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
	
	func fetchPlace() async throws {
		var placeArray: [Place] = []
		guard let localNameText = LocalName.randomElement()?.key else { return }
		placeArray = try await FirebaseService.fetchPlace(localNameText: localNameText,
														  fetchKind: .couple)
		guard let localName = LocalName[localNameText] else { return }
		self.coupleTodayPlaceView.todayPlaceText.text = "\(localName)의 오늘 장소"
		self.coupleTodayPlaceView.mainDatePlaceList.append(contentsOf: placeArray)
		self.coupleTodayPlaceView.mainDatePlaceList.shuffle()
		
		self.contentView.removeArrangedSubview(activityIndicator)
		self.contentView.addArrangedSubview(coupleTodayPlaceView)
	}
	
	func coupleTabViewModelBinding() {
		guard let coupleTabViewModel = coupleTabViewModel else { return }
		
		coupleTabViewModel.output.beginCoupleDayOutput
			.bind { [weak self] beginCoupleDay in
				if let userDatas = RealmService.shared.getUserDatas().first {
					DispatchQueue.main.async {
						self?.coupleProfileImageAndDayView.dayText.text = beginCoupleDay
					}
					let dayData: [String: Any] = [
						"dayData": String(describing: userDatas.beginCoupleDay)
					]
					try? WCSession.default.updateApplicationContext(dayData)
				}
			}
			.disposed(by: disposeBag)
		
		coupleTabViewModel.output.homeMainImageDataOutput
			.bind { [weak self] imageData in
				DispatchQueue.main.async {
					self?.coupleBackgroundImageView.backgroundImageView.image = UIImage(data: imageData)
					guard let loadingCheck = self?.loadingCheck else { return }
					if !loadingCheck {
						self?.afterImageLoadingView()
						self?.loadingCheck = true
					}
					guard let data = UIImage(data: coupleTabViewModel.output.homeMainImageDataOutput.value)?.jpegData(compressionQuality: 0.1) else { return }
					let imageData: [String: Any] = ["imageData": data]
					WCSession.default.transferUserInfo(imageData)
				}
			}
			.disposed(by: disposeBag)
		
		coupleTabViewModel.output.myProfileImageDataOutput
			.bind { [weak self] imageData in
				DispatchQueue.main.async {
					self?.coupleProfileImageAndDayView.myProfileImageView.image = UIImage(data: imageData)
				}
			}
			.disposed(by: disposeBag)
		
		coupleTabViewModel.output.partnerProfileImageDataOutput
			.bind { [weak self] imageData in
				DispatchQueue.main.async {
					self?.coupleProfileImageAndDayView.partnerProfileImageView.image = UIImage(data: imageData)
				}
			}
			.disposed(by: disposeBag)
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
		let imagePartView = imageLoadingFlag ?
		self.coupleBackgroundImageView.backgroundImageView :
		self.backgroundImageActivityIndicatorView
		
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
		coupleTabViewModel?.input.myProfileImageDataTrigger.onNext(())
		coupleTabViewModel?.input.partnerProfileImageDataTrigger.onNext(())
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
			self?.presentCropViewController(image: imageData as? UIImage ?? UIImage())
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
			coupleTabViewModel.input.myProfileImageDataTrigger.onNext(())
		} else {
			RealmService.shared.updatePartnerProfileImage(partnerProfileImage: image)
			coupleTabViewModel.input.partnerProfileImageDataTrigger.onNext(())
		}
		dismiss(animated: true, completion: nil)
	}
}
