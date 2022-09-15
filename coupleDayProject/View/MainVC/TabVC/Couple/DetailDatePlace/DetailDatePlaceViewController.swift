import UIKit
import Kingfisher
import MapKit
import SnapKit

final class DetailDatePlaceViewController: UIViewController {
    
    // MARK: bottom sheet 작업 중
    //
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    let bottomHeight: CGFloat = 300
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
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
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
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
    
    let bottomSheetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 27
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    let openMapBottomSheetContentView = OpenMapBottomSheetContentView()
    // 기존 화면을 흐려지게 만들기 위한 뷰
    private let dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    // dismiss Indicator View UI 구성 부분
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
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
    
    // MARK: Properties
    //
    var datePlace: DatePlaceModel?
    
    // MARK: Views
    //
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
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.titleLabel?.font =  UIFont(name: "GangwonEduAllLight", size: 15)
        button.layer.cornerRadius = 10
        button.setTitle("지도 앱 열기", for: .normal)
        return button
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
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBackBtn()
        
        // MARK: 바텀 시트 작업 중
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        view.addSubview(dismissIndicatorView)

        bottomSheetView.addSubview(openMapBottomSheetContentView)
        openMapBottomSheetContentView.snp.makeConstraints { make in
            //            make.top.left.right.bottom.equalTo(0)
            //            make.height.equalTo(100)
            //            make.width.equalToSuperview()
            //            make.centerX.equalToSuperview()
            //            make.centerY.equalToSuperview()
        }
        dimmedBackView.alpha = 0.0
        
        setupLayout()
        setupGestureRecognizer()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        // navigationController 배경 투명하게 변경
        //
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapZoomInAnimation() // 줌인되는 애니메이션 -> 뷰가 나타난 직후 일어나야해서 viewDidAppear
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        datePlaceCarouselView.invalidateTimer()
    }
    
    // MARK: Functions
    //
    private func setUpView() {
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
            make.bottom.equalToSuperview().offset(-50) // 이 부분이 가장 중요 -> contentView height를 마지막에 있는 뷰 기준으로 높이 설정
        }
    }
    private func setUpBackBtn() {
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
    }
    private func mapZoomInAnimation() {
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
    @objc private func oepnMapAppBtnTap() {
        showBottomSheet()
    }
}

// MARK: Extension
//
extension DetailDatePlaceViewController: MKMapViewDelegate, CLLocationManagerDelegate {
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
