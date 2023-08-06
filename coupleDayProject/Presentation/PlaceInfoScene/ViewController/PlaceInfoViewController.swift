import MapKit
import UIKit

import Kingfisher

final class PlaceInfoViewController: BaseViewController {
	
	//MARK: - Properties
	
	var datePlace: Place?
	private var bottomSheetViewTopConstraint: NSLayoutConstraint!
	private let bottomHeight: CGFloat = 300
	
	//MARK: - Views
	
	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsVerticalScrollIndicator = false
		view.contentInsetAdjustmentBehavior = .never
		return view
	}()
	
	private let contentView : UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let placeImageNameAddressView = PlaceImageNameAddressView()
	
	private let placeMapView = PlaceMapView()
	
	private let placeMapBottomSheetView = PlaceMapBottomSheetView()
	
	lazy var datePlaceCarouselView: PlaceCarouselView = {
		var copyDatePlaceImageUrl = self.datePlace?.imageUrl
		copyDatePlaceImageUrl?.removeFirst()
		let view = PlaceCarouselView(imageUrlArray: copyDatePlaceImageUrl ?? [])
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let placeIntroduceView = PlaceIntroduceView()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.isNavigationBarHidden = false
		self.navigationItem.title = ""
		
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		placeMapView.mapZoomInAnimation()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		datePlaceCarouselView.placeCarouselCollectionView.invalidateTimer()
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(placeImageNameAddressView)
		contentView.addSubview(placeMapView)
		contentView.addSubview(datePlaceCarouselView)
		contentView.addSubview(placeIntroduceView)
		
		view.addSubview(placeMapBottomSheetView)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
		
		NSLayoutConstraint.activate([
			contentView.widthAnchor.constraint(equalToConstant: view.bounds.width),
			contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
		])
		
		NSLayoutConstraint.activate([
			placeImageNameAddressView.topAnchor.constraint(equalTo: contentView.topAnchor),
			placeImageNameAddressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			placeImageNameAddressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			placeImageNameAddressView.heightAnchor.constraint(equalToConstant: 480)
		])
		
		NSLayoutConstraint.activate([
			placeMapView.topAnchor.constraint(equalTo: placeImageNameAddressView.bottomAnchor, constant: 30),
			placeMapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			placeMapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			placeMapView.heightAnchor.constraint(equalToConstant: 320)
		])
		
		NSLayoutConstraint.activate([
			placeMapBottomSheetView.topAnchor.constraint(equalTo: view.topAnchor),
			placeMapBottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			placeMapBottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			placeMapBottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		NSLayoutConstraint.activate([
			datePlaceCarouselView.topAnchor.constraint(equalTo: placeMapView.bottomAnchor, constant: 20),
			datePlaceCarouselView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			datePlaceCarouselView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			datePlaceCarouselView.heightAnchor.constraint(equalToConstant: 300)
		])
		
		NSLayoutConstraint.activate([
			placeIntroduceView.topAnchor.constraint(equalTo: datePlaceCarouselView.bottomAnchor, constant: 40),
			placeIntroduceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			placeIntroduceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			placeIntroduceView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
		])
	}
	
	override func setupView() {
		setupBackButton()
		setUpGestureRecognizer()
		
		placeMapView.datePlace = self.datePlace
		placeMapView.delegate = self
		placeMapBottomSheetView.datePlace = self.datePlace
		placeMapBottomSheetView.delegate = self
		
		placeMapBottomSheetView.alpha = 0.0
		
		
		guard let datePlace else { return }
		guard let url = datePlace.imageUrl.first else { return }
		placeImageNameAddressView.datePlaceImageView.setImage(with: url)
		placeImageNameAddressView.datePlaceName.text = datePlace.placeName
		placeImageNameAddressView.datePlaceAddress.text = datePlace.address
		
		placeIntroduceView.introduceTitle.text = datePlace.introduce[0]
		let introduceContentValue = NSAttributedString(string: datePlace.introduce[1]).withLineSpacing(10)
		placeIntroduceView.introduceContent.attributedText = introduceContentValue
	}
}

private extension PlaceInfoViewController {
	func setUpGestureRecognizer() {
		let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
		swipeGesture.direction = .down
		view.addGestureRecognizer(swipeGesture)
	}
	
	func showBottomSheet() {
		let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
		let bottomPadding: CGFloat = view.safeAreaInsets.bottom
		
		placeMapBottomSheetView.bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
		
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
			self.placeMapBottomSheetView.dimmedBackView.alpha = 0.5
			self.placeMapBottomSheetView.alpha = 1.0
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	func hideBottomSheetAndGoBack() {
		let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
		let bottomPadding = view.safeAreaInsets.bottom
		placeMapBottomSheetView.bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
		
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
			self.placeMapBottomSheetView.dimmedBackView.alpha = 0.0
			self.view.layoutIfNeeded()
		}) { _ in
			self.placeMapBottomSheetView.alpha = 0.0
			if self.presentingViewController != nil {
				self.dismiss(animated: false, completion: nil)
			}
		}
	}
	
	@objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
		if recognizer.state == .ended {
			switch recognizer.direction {
			case .down:
				hideBottomSheetAndGoBack()
			default:
				break
			}
		}
	}
}

extension PlaceInfoViewController: PlaceMapViewDelegate {
	func didOpenMapAppBtnTap() {
		showBottomSheet()
	}
}

extension PlaceInfoViewController: PlaceMapBottomSheetViewDelegate {
	func didDimmedViewTapped() {
		hideBottomSheetAndGoBack()
	}
	
	func failOpenkakaoMaps() {
		let alert = UIAlertController(
			title: "카카오맵으로 열기 실패",
			message: "앱 설치 상태를 확인해주세요",
			preferredStyle: UIAlertController.Style.alert
		)
		let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
		alert.addAction(okAction)
		present(alert, animated: false, completion: nil)
	}
	
	func failOpenGoogleMaps() {
		let alert = UIAlertController(
			title: "구글 맵스로 열기 실패",
			message: "앱 설치 상태를 확인해주세요",
			preferredStyle: UIAlertController.Style.alert
		)
		let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
		alert.addAction(okAction)
		present(alert, animated: false, completion: nil)
	}
}
