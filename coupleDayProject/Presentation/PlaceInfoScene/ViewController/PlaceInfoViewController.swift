import MapKit
import UIKit

import Kingfisher
import SnapKit

final class PlaceInfoViewController: UIViewController {
	
	//MARK: - Properties
	
	var datePlace: Place?
	private var bottomSheetViewTopConstraint: NSLayoutConstraint!
	private let bottomHeight: CGFloat = 300
	
	//MARK: - Views
	
	let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsVerticalScrollIndicator = false
		view.contentInsetAdjustmentBehavior = .never
		return view
	}()
	let contentView : UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	let datePlaceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	lazy var datePlaceCarouselView: DatePlaceCarouselView = {
		var copyDatePlaceImageUrl = datePlace!.imageUrl
		copyDatePlaceImageUrl.removeFirst()
		let view = DatePlaceCarouselView(imageUrlArray: copyDatePlaceImageUrl)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	let datePlaceName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		return label
	}()
	let datePlaceAddress: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 15)
		label.textColor = .gray
		return label
	}()
	let mapAddressTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "위치"
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		return label
	}()
	let mapView: MKMapView = {
		let view = MKMapView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	let oepnMapAppBtn: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.systemGray5.cgColor
		button.titleLabel?.font =  UIFont(name: "GangwonEduAllLight", size: 15)
		button.setTitleColor(
			UserDefaults.standard.bool(forKey: "darkModeState") ? .white : .black,
			for: .normal
		)
		button.layer.cornerRadius = 10
		button.setTitle("지도 앱 열기", for: .normal)
		return button
	}()
	private let bottomSheetView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(named: "bgColor")
		view.layer.cornerRadius = 27
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		view.clipsToBounds = true
		return view
	}()
	private let dimmedBackView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		return view
	}()
	private let dismissIndicatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGray2
		view.layer.cornerRadius = 3
		
		return view
	}()
	private let openMapsTitleText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		label.text = "지도 앱 열기"
		return label
	}()
	private let googleMapsIcon: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = UIImage(named: "googleMapSymbol")
		view.layer.cornerRadius = 25
		view.clipsToBounds = true
		view.contentMode = .scaleAspectFill
		return view
	}()
	private let googleMapsText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 18)
		label.text = "구글 맵스"
		return label
	}()
	private lazy var googleMapsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.spacing = 20
		return stackView
	}()
	private let kakaoMapsIcon: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = UIImage(named: "kakaoMapSymbol")
		view.layer.cornerRadius = 25
		view.clipsToBounds = true
		view.contentMode = .scaleAspectFill
		return view
	}()
	private let kakaoMapsText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 18)
		label.text = "카카오맵"
		return label
	}()
	private lazy var kakaoMapsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.spacing = 20
		return stackView
	}()
	let introduceTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		return label
	}()
	let introduceContent: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 15)
		label.numberOfLines = 0
		return label
	}()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
		setUpBackBtn()
		setUpBottomSheetLayout()
		setUpGestureRecognizer()
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
		mapZoomInAnimation()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		datePlaceCarouselView.invalidateTimer()
	}
}

private extension PlaceInfoViewController {
	
	//MARK: - Functions
	
	func setUpView() {
		oepnMapAppBtn.addTarget(self, action: #selector(oepnMapAppBtnTap), for: .touchUpInside)
		
		mapView.delegate = self
		
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		datePlaceImageView.setImage(with: (datePlace?.imageUrl.first)!)
		contentView.addSubview(datePlaceImageView)
		
		datePlaceName.text = datePlace?.placeName
		contentView.addSubview(datePlaceName)
		datePlaceAddress.text = datePlace?.address
		contentView.addSubview(datePlaceAddress)
		
		contentView.addSubview(mapAddressTitle)
		contentView.addSubview(mapView)
		
		contentView.addSubview(oepnMapAppBtn)
		
		contentView.addSubview(datePlaceCarouselView)
		
		introduceTitle.text = datePlace!.introduce[0]
		contentView.addSubview(introduceTitle)
		let introduceContentValue = NSAttributedString(string: datePlace!.introduce[1]).withLineSpacing(10)
		introduceContent.attributedText = introduceContentValue
		contentView.addSubview(introduceContent)
		
		scrollView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		contentView.snp.makeConstraints { (make) in
			make.width.equalToSuperview()
			make.centerX.top.bottom.equalToSuperview()
		}
		datePlaceImageView.snp.makeConstraints { make in
			make.top.left.right.equalTo(contentView)
			make.height.equalTo(400)
		}
		datePlaceName.snp.makeConstraints { make in
			make.top.equalTo(datePlaceImageView.snp.bottom).offset(30)
			make.left.equalTo(contentView.snp.left).offset(20)
		}
		datePlaceAddress.snp.makeConstraints { make in
			make.top.equalTo(datePlaceName.snp.bottom).offset(10)
			make.left.equalTo(contentView.snp.left).offset(20)
		}
		mapAddressTitle.snp.makeConstraints { make in
			make.top.equalTo(datePlaceAddress.snp.bottom).offset(30)
			make.left.equalTo(contentView.snp.left).offset(20)
		}
		mapView.snp.makeConstraints { make in
			make.top.equalTo(mapAddressTitle.snp.bottom).offset(20)
			make.left.equalTo(contentView.snp.left).offset(20)
			make.right.equalTo(contentView.snp.right).offset(-20)
			make.height.equalTo(200)
		}
		oepnMapAppBtn.snp.makeConstraints { make in
			make.top.equalTo(mapView.snp.bottom).offset(20)
			make.left.equalTo(contentView.snp.left).offset(20)
			make.right.equalTo(contentView.snp.right).offset(-20)
			make.height.equalTo(50)
		}
		datePlaceCarouselView.snp.makeConstraints { make in
			make.top.equalTo(oepnMapAppBtn.snp.bottom).offset(40)
			make.left.equalTo(contentView.snp.left).offset(20)
			make.right.equalTo(contentView.snp.right).offset(-20)
			make.height.equalTo(300)
		}
		introduceTitle.snp.makeConstraints { make in
			make.top.equalTo(datePlaceCarouselView.snp.bottom).offset(40)
			make.left.equalTo(contentView.snp.left).offset(20)
		}
		introduceContent.snp.makeConstraints { make in
			make.top.equalTo(introduceTitle.snp.bottom).offset(10)
			make.right.equalTo(contentView.snp.right).offset(-20)
			make.left.equalTo(contentView.snp.left).offset(20)
			make.bottom.equalToSuperview().offset(-50)
		}
	}
	
	func setUpBackBtn() {
		self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
		UIBarButtonItem.appearance().setTitleTextAttributes([
			NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any
		], for: .normal)
		self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
		self.view.backgroundColor = UIColor(named: "bgColor")
	}
	
	func mapZoomInAnimation() {
		guard let datePlace = datePlace else { return }
		guard let latitude = Double(datePlace.latitude) else { return }
		guard let longitude = Double(datePlace.longitude) else { return }
		let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		mapView.setRegion(region, animated: true)
		let pin = MKPointAnnotation()
		pin.coordinate = coordinate
		pin.title = datePlace.placeName
		mapView.addAnnotation(pin)
	}
	
	func setUpGestureRecognizer() {
		let dimmedTap = UITapGestureRecognizer(
			target: self,
			action: #selector(dimmedViewTapped(_:))
		)
		dimmedBackView.addGestureRecognizer(dimmedTap)
		dimmedBackView.isUserInteractionEnabled = true
		
		let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
		swipeGesture.direction = .down
		view.addGestureRecognizer(swipeGesture)
	}
	
	func setUpBottomSheetLayout() {
		view.addSubview(dimmedBackView)
		view.addSubview(bottomSheetView)
		view.addSubview(dismissIndicatorView)
		
		kakaoMapsStackView.addArrangedSubview(kakaoMapsIcon)
		kakaoMapsStackView.addArrangedSubview(kakaoMapsText)
		
		googleMapsStackView.addArrangedSubview(googleMapsIcon)
		googleMapsStackView.addArrangedSubview(googleMapsText)
		
		bottomSheetView.addSubview(openMapsTitleText)
		bottomSheetView.addSubview(googleMapsStackView)
		bottomSheetView.addSubview(kakaoMapsStackView)
		
		let googleMapsTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(openGoogleMaps)
		)
		googleMapsStackView.isUserInteractionEnabled = true
		googleMapsStackView.addGestureRecognizer(googleMapsTapGesture)
		
		let kakaoMapsTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(openkakaoMaps)
		)
		kakaoMapsStackView.isUserInteractionEnabled = true
		kakaoMapsStackView.addGestureRecognizer(kakaoMapsTapGesture)
		
		openMapsTitleText.snp.makeConstraints { make in
			make.top.equalTo(50)
			make.left.equalTo(40)
			make.right.equalTo(-40)
		}
		
		googleMapsStackView.snp.makeConstraints { make in
			make.top.equalTo(openMapsTitleText.snp.bottom).offset(30)
			make.left.equalTo(40)
			make.right.equalTo(-40)
		}
		kakaoMapsStackView.snp.makeConstraints { make in
			make.top.equalTo(googleMapsStackView.snp.bottom).offset(10)
			make.left.equalTo(40)
			make.right.equalTo(-40)
		}
		googleMapsIcon.snp.makeConstraints { make in
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		kakaoMapsIcon.snp.makeConstraints { make in
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		dimmedBackView.alpha = 0.0
		dimmedBackView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			dimmedBackView.topAnchor.constraint(equalTo: view.topAnchor),
			dimmedBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			dimmedBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			dimmedBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
		let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
		bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
		NSLayoutConstraint.activate([
			bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			bottomSheetViewTopConstraint
		])
		
		dismissIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			dismissIndicatorView.widthAnchor.constraint(equalToConstant: 102),
			dismissIndicatorView.heightAnchor.constraint(equalToConstant: 7),
			dismissIndicatorView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 12),
			dismissIndicatorView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
		])
	}
	
	func showBottomSheet() {
		let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
		let bottomPadding: CGFloat = view.safeAreaInsets.bottom
		
		bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
		
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
			self.dimmedBackView.alpha = 0.5
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	func hideBottomSheetAndGoBack() {
		let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
		let bottomPadding = view.safeAreaInsets.bottom
		bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
			self.dimmedBackView.alpha = 0.0
			self.view.layoutIfNeeded()
		}) { _ in
			if self.presentingViewController != nil {
				self.dismiss(animated: false, completion: nil)
			}
		}
	}
	
	@objc func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
		hideBottomSheetAndGoBack()
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
	
	@objc func oepnMapAppBtnTap() {
		showBottomSheet()
	}
	
	@objc func openGoogleMaps() {
		let alert = UIAlertController(
			title: "구글 맵스로 열기 실패",
			message: "앱 설치 상태를 확인해주세요",
			preferredStyle: UIAlertController.Style.alert
		)
		let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
		alert.addAction(okAction)
		
		guard let latitude = Double(datePlace!.latitude) else { return }
		guard let longitude = Double(datePlace!.longitude) else { return }
		let url = URL(string: "comgooglemaps://?center=\(latitude),\(longitude)&zoom=17&mapmode=standard")
		
		if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!){
			UIApplication.shared.open(url!, options: [:], completionHandler: nil)
		} else {
			present(alert, animated: false, completion: nil)
		}
	}
	
	@objc func openkakaoMaps() {
		let alert = UIAlertController(
			title: "카카오맵으로 열기 실패",
			message: "앱 설치 상태를 확인해주세요",
			preferredStyle: UIAlertController.Style.alert
		)
		let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
		alert.addAction(okAction)
		
		guard let latitude = Double(datePlace!.latitude) else { return }
		guard let longitude = Double(datePlace!.longitude) else { return }
		let url = URL(string: "kakaomap://look?p=\(latitude),\(longitude)")
		if UIApplication.shared.canOpenURL(URL(string:"kakaomap://")!){
			UIApplication.shared.open(url!, options: [:], completionHandler: nil)
		} else {
			present(alert, animated: false, completion: nil)
		}
	}
}

extension PlaceInfoViewController: MKMapViewDelegate, CLLocationManagerDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
		let reuseId = "pin"
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView // pin 모양 변경
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			if let unwrappingPinView = pinView {
				unwrappingPinView.canShowCallout = true
				unwrappingPinView.rightCalloutAccessoryView = UIButton(type: .infoDark)
			}
		}
		else {
			if let unwrappingPinView = pinView {
				unwrappingPinView.annotation = annotation
			}
		}
		return pinView
	}
}
