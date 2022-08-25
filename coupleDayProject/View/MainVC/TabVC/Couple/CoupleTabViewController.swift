import UIKit
import Photos
import TOCropViewController
import CropViewController
import GoogleMobileAds
import WatchConnectivity

final class CoupleTabViewController: UIViewController {

    // MARK: Properties
    //
    private var coupleTabViewModel: CoupleTabViewModel?
    init(coupleTabViewModel: CoupleTabViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coupleTabViewModel = coupleTabViewModel
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var mainDatePlaceList = [DatePlace]()
    private let imagePickerController = UIImagePickerController()
    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값
    
    private let mainImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 메인 이미지 로딩 뷰
    private let myProfileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 내 프로필 이미지 로딩 뷰
    private let profileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 상대 프로필 이미지 로딩 뷰
    
    private var loadingCheck = false
    
    // MARK: Views
    //
    private let coupleTabStackView: UIStackView = { // 커플 탭 전체 뷰
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        return view
    }()
    private let topTabBackView: UIView = { // 상단 탭 뒤에 뷰
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let mainImageView: UIImageView = { // 메인 이미지 뷰
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let emptyView: UIView = { // 하단 빈 공간 채우는 뷰
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let coupleStackView: UIStackView = { // 내 프로필 + day + 상대 프로필
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let myProfileUIImageView: UIImageView = { // 내 프로필 뷰
        let view = UIImageView()
        return view
    }()
    private let partnerProfileUIImageView: UIImageView = { // 상대 프로필 뷰
        let view = UIImageView()
        return view
    }()
    private let iconDayStackView: UIStackView = { // 하트 아이콘 + day
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let loveIconView: UIImageView = { // 하트 아이콘
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: UIImage.SymbolWeight.light))
        view.tintColor = TrendingConstants.appMainColor
        return view
    }()
    private let mainTextLabel: UILabel = { // day
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "GangwonEduAllLight", size: 25)
        return label
    }()
    private lazy var titleDatePlace: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllBold", size: CommonSize.coupleTextBigSize)
        return label
    }()
    private lazy var carouselCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0 // 행과 열 사이 간격
        flowLayout.minimumInteritemSpacing = 0 // 행 사이 간격
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
    
    private let admobView: GADBannerView = {
        var view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var DatePlaceStackView: UIStackView = { // 오늘의 데이트 장소 stackView
        var stackView = UIStackView(arrangedSubviews: [titleDatePlace, carouselCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = UIColor(named: "bgColor")
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func viewWillAppear(_ animated: Bool) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFirebaseData { [weak self] in
            guard let self = self else { return }
            self.coupleTabStackView.removeArrangedSubview(self.activityIndicator)
            self.coupleTabStackView.addArrangedSubview(self.DatePlaceStackView)
            
            // fadeIn Animation
            //
            self.DatePlaceStackView.alpha = 0
            self.DatePlaceStackView.fadeIn()
            
            NSLayoutConstraint.activate([
                self.DatePlaceStackView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                self.DatePlaceStackView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            ])
        }
        
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(DemoDatePlaceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        imagePickerController.delegate = self
        
        // 로딩 뷰 세팅, 제일 큰 사진 로딩 끝나면 beforeLoadingSetupView -> afterLoadingSetupView 변경
        //
        beforeLoadingSetupView()
        
        // ViewModel DataBinding
        //
        coupleTabViewModel!.beginCoupleDay.bind { [weak self] beginCoupleDay in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.mainTextLabel.text = beginCoupleDay
            }
            // watch, days 택스트 value는 updateApplicationContext 방법으로 연동
            //
            let dayData: [String: Any] = ["dayData": String(describing: RealmManager.shared.getUserDatas().first!.beginCoupleDay)]
            try? WCSession.default.updateApplicationContext(dayData)
        }
        coupleTabViewModel!.mainImageData.bind { [weak self] imageData in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: imageData)
                if !self.loadingCheck {
                    self.afterLoadingSetupView()
                    self.loadingCheck = true
                }
                
                // watch, 메인 이미지는 transferUserInfo 방법으로 이미지 연동
                // watch 앱에 보내는 image, 크기 제한이 심해서 0.1 화질로 보냄 -> 0.1이 제일 작은 크기인 듯..? 0.1이 0.01, 0.001 이랑 차이없음
                //
                let data = UIImage(data: self.coupleTabViewModel!.mainImageData.value)?.jpegData(compressionQuality: 0.1)
                let imageData: [String: Any] = ["imageData": data!]
                WCSession.default.transferUserInfo(imageData)
            }
        }
        coupleTabViewModel!.myProfileImageData.bind({ [weak self] imageData in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.myProfileUIImageView.image = UIImage(data: imageData)
            }
        })
        coupleTabViewModel!.partnerProfileImageData.bind({ [weak self] imageData in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.partnerProfileUIImageView.image = UIImage(data: imageData)
            }
        })
    }
    
    // MARK: Functions
    //
    // Firebase Data 불러오는 메서드
    // 불러오면 컬렉션 뷰 reaload
    //
    fileprivate func loadFirebaseData(completion: @escaping () -> ()) {
        FirebaseManager.shared.firestore.collection("daegu").getDocuments { [self] (querySnapshot, error) in
            guard error == nil else { return }
            for document in querySnapshot!.documents {
                var tempDatePlaceValue = DatePlace()
                guard let localNameText = LocalName.randomElement()?.keys.first else { return }
                
                tempDatePlaceValue.placeName = document.documentID
                tempDatePlaceValue.address = document.data()["address"] as! String
                tempDatePlaceValue.shortAddress = document.data()["shortAddress"] as! String
                tempDatePlaceValue.introduce = document.data()["introduce"] as! String
                tempDatePlaceValue.number = document.data()["number"] as! String
                tempDatePlaceValue.imageUrl = document.data()["imageUrl"] as! Array<String>
                
                titleDatePlace.text = "\(localNameText)의 오늘 장소"
                mainDatePlaceList.append(tempDatePlaceValue)
                mainDatePlaceList.shuffle()
            }
            DispatchQueue.main.async { [self] in
                carouselCollectionView.reloadData()
            }
            completion()
        }
    }
    
    // 이미지 불러오는동안 보이는 임시 뷰
    //
    fileprivate func beforeLoadingSetupView() {
        view.backgroundColor = UIColor(named: "bgColor")
        
        // 이미지 로딩 뷰 세팅
        //
        mainImageActivityIndicatorView.startAnimating()
        mainImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        myProfileImageActivityIndicatorView.startAnimating()
        myProfileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        profileImageActivityIndicatorView.startAnimating()
        profileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpView(imageLoadingFlag: false)
    }
    
    // 이미지 불러오고나서 보이는 뷰
    //
    fileprivate func afterLoadingSetupView() {
        view.backgroundColor = UIColor(named: "bgColor")
        
        // 이미지 로딩 뷰 제거
        //
        profileImageActivityIndicatorView.stopAnimating()
        myProfileImageActivityIndicatorView.stopAnimating()
        mainImageActivityIndicatorView.stopAnimating()
        
        setUpView(imageLoadingFlag: true)
    }
    
    fileprivate func setUpView(imageLoadingFlag: Bool) {
        
        // 내 프로필 사진 변경 제스처
        //
        let tapGestureMyProfileUIImageView = UITapGestureRecognizer(target: self, action: #selector(myProfileTap(_:)))
        myProfileUIImageView.addGestureRecognizer(tapGestureMyProfileUIImageView)
        myProfileUIImageView.isUserInteractionEnabled = true
        myProfileUIImageView.layer.cornerRadius = CommonSize.coupleProfileSize/2 // 둥글게
        myProfileUIImageView.clipsToBounds = true
        
        // 상대방 프로필 사진 변경 제스처
        //
        let tapGesturePartnerProfileUIImageView = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:)))
        partnerProfileUIImageView.isUserInteractionEnabled = true
        partnerProfileUIImageView.addGestureRecognizer(tapGesturePartnerProfileUIImageView)
        partnerProfileUIImageView.layer.cornerRadius = CommonSize.coupleProfileSize/2 // 둥글게
        partnerProfileUIImageView.clipsToBounds = true
        
        let imagePartView = imageLoadingFlag ? self.mainImageView : self.mainImageActivityIndicatorView
        
        view.addSubview(coupleTabStackView)
        coupleTabStackView.addArrangedSubview(topTabBackView)
        coupleTabStackView.addArrangedSubview(imagePartView)
        coupleTabStackView.addArrangedSubview(coupleStackView)
        coupleTabStackView.addArrangedSubview(activityIndicator)
        
        // 광고 무효트래픽으로 인한 게재 제한.. 일단 광고 제거
        //
        // coupleTabStackView.addArrangedSubview(admobView)
        // admobView.widthAnchor.constraint(equalToConstant: GADAdSizeBanner.size.width).isActive = true
        // admobView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height).isActive = true
        // // ca-app-pub-1976572399218124/5279479661 -> 광고 단위 ID
        // // ca-app-pub-3940256099942544/2934735716 -> test Key
        // admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        // admobView.rootViewController = self
        // admobView.load(GADRequest())
        // admobView.delegate = self
        
        coupleStackView.addArrangedSubview(myProfileUIImageView)
        coupleStackView.addArrangedSubview(iconDayStackView)
        coupleStackView.addArrangedSubview(partnerProfileUIImageView)
        
        iconDayStackView.addArrangedSubview(loveIconView)
        iconDayStackView.addArrangedSubview(mainTextLabel)
        
        coupleTabStackView.setCustomSpacing(15, after: imagePartView)
        coupleTabStackView.setCustomSpacing(10, after: coupleStackView)
        
        // set autolayout
        // UIScreen.main.bounds.size.height -> 디바이스 별 height 이용해서 해상도 비율 맞춤
        //
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
            
            coupleStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 45),
            coupleStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -45),
            coupleStackView.heightAnchor.constraint(equalToConstant: CommonSize.coupleStackViewHeightSize),
            
            coupleTabStackView.topAnchor.constraint(equalTo: view.topAnchor),
            coupleTabStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            coupleTabStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            coupleTabStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    @objc func myProfileTap(_ gesture: UITapGestureRecognizer) {
        whoProfileChange = "my"
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @objc func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
        whoProfileChange = "partner"
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: Extension
//
// ImagePicker + CropViewController
//
extension CoupleTabViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    // ImagePicker
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = info[.editedImage] is UIImage ? info[UIImagePickerController.InfoKey.editedImage] : info[UIImagePickerController.InfoKey.originalImage]
        
        // 이미지 고르면 이미지피커 dismiis 하고 이미지 데이터 넘기면서 presentCropViewController 띄우기
        //
        dismiss(animated: true) {
            self.presentCropViewController(image: imageData as! UIImage)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // CropViewController
    // circular -> 범위 둥글게, aspectRatioLockEnabled-> 비율 고정
    //
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
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        // 내 프로필 변경, 상대 프로필 변경
        //
        if whoProfileChange == "my" {
            RealmManager.shared.updateMyProfileImage(myProfileImage: image)
            self.coupleTabViewModel!.setMyProfileIcon()
        } else {
            RealmManager.shared.updatePartnerProfileImage(partnerProfileImage: image)
            self.coupleTabViewModel!.setPartnerProfileIcon()
        }
        dismiss(animated: true, completion: nil)
    }
}

// Google AdMob Delegate
//
extension CoupleTabViewController : GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}

extension CoupleTabViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if self.mainDatePlaceList.count > indexPath.item {
            if let cell = cell as? DemoDatePlaceCollectionViewCell {
                cell.datePlaceModel = mainDatePlaceList[indexPath.item]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // cell click
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CommonSize.coupleCellImageSize + 10, height: carouselCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension CoupleTabViewController: UICollectionViewDelegate {}
