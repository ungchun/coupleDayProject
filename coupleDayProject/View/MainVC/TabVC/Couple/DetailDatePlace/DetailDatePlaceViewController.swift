import UIKit
import Kingfisher
import MapKit
import SnapKit

final class DetailDatePlaceViewController: UIViewController {
    
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
        guard let datePlace = datePlace else { return }
        
        // 줌인되는 애니메이션 -> 뷰가 나타난 직후 일어나야해서 viewDidAppear
        //
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        datePlaceCarouselView.invalidateTimer()
    }
    
    // MARK: Functions
    //
    private func setUpView() {
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
        datePlaceCarouselView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(40)
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
