import UIKit
import Kingfisher
import MapKit
import SnapKit

class DatePlaceViewController: UIViewController {
    
    // MARK: Properties
    //
    var datePlace: DatePlace?
    
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
    let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var datePlaceCarouselView: DatePlaceCarouselView = {
        let view = DatePlaceCarouselView(imageUrlArray: datePlace!.imageUrl)
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
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    let mapAddressTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "위치"
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        return label
    }()
    let mapAddressContent: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        datePlaceCarouselView.imageUrlArray = datePlace?.imageUrl
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let url = URL(string: (datePlace?.imageUrl.first)!)
        mainImageView.kf.setImage(with: url)
        contentView.addSubview(mainImageView)
        
        datePlaceName.text = datePlace?.placeName
        contentView.addSubview(datePlaceName)
        
        datePlaceAddress.text = datePlace?.address
        contentView.addSubview(datePlaceAddress)
        
        contentView.addSubview(datePlaceCarouselView)
        NSLayoutConstraint.activate([
            datePlaceCarouselView.topAnchor.constraint(equalTo: datePlaceAddress.bottomAnchor, constant: 30),
            datePlaceCarouselView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            datePlaceCarouselView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            datePlaceCarouselView.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        introduceTitle.text = datePlace!.introduce[0]
        contentView.addSubview(introduceTitle)
        
        let introduceContentValue = NSAttributedString(string: datePlace!.introduce[1]).withLineSpacing(10)
        introduceContent.attributedText = introduceContentValue
        contentView.addSubview(introduceContent)
        
        contentView.addSubview(mapAddressTitle)
        contentView.addSubview(mapView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        mainImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(400)
        }
        datePlaceName.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        datePlaceAddress.snp.makeConstraints { make in
            make.top.equalTo(datePlaceName.snp.bottom).offset(10)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        mapAddressTitle.snp.makeConstraints { make in
            make.top.equalTo(introduceContent.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(mapAddressTitle.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-50) // 이 부분이 가장 중요 -> contentView height를 마지막에 있는 뷰 기준으로 높이 설정
        }
        introduceTitle.snp.makeConstraints { make in
            make.top.equalTo(datePlaceCarouselView.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        introduceContent.snp.makeConstraints { make in
            make.top.equalTo(introduceTitle.snp.bottom).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
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
        // 줌인되는 애니메이션 -> 뷰가 나타난 직후 일어나야해서 viewDidAppear
        //
        guard let latitude = Double(datePlace!.latitude) else { return }
        guard let longitude = Double(datePlace!.longitude) else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = datePlace?.placeName
        mapView.addAnnotation(pin)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        datePlaceCarouselView.invalidateTimer()
    }
}
