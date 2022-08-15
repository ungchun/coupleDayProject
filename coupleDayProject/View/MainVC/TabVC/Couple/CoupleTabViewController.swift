import UIKit
import Photos
import TOCropViewController
import CropViewController
import GoogleMobileAds
import WatchConnectivity

class CoupleTabViewController: UIViewController {
    
    // MARK: Properties
    //
    private var mainDatePlaceList = [DatePlace]()
    private let coupleTabViewModel = CoupleTabViewModel()
    
    private let imagePickerController = UIImagePickerController()
    
    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값
    
    private let mainImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 메인 이미지 로딩 뷰
    private let myProfileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 내 프로필 이미지 로딩 뷰
    private let profileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 상대 프로필 이미지 로딩 뷰
    
    private let textBigSize = UIScreen.main.bounds.size.height > 850 ? 25.0 : 22.0
    private let textSmallSize = UIScreen.main.bounds.size.height > 850 ? 19.0 : 17.0
    private let profileSize = UIScreen.main.bounds.size.height > 850 ? 75.0 : 70.0
    private let coupleStackViewHeightSize = UIScreen.main.bounds.size.height > 850 ? UIScreen.main.bounds.size.height / 8 : UIScreen.main.bounds.size.height / 10
    
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
        label.text = "대구의 오늘 장소"
        label.font = UIFont(name: "GangwonEduAllBold", size: textBigSize)
        return label
    }()
    let carouselCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0 // 행과 열 사이 간격
        flowLayout.minimumInteritemSpacing = 0 // 행 사이 간격
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.red
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let admobView: GADBannerView = {
        var view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var DatePlaceStackView: UIStackView = { // 오늘의 데이트 장소 stackView
        var stackView = UIStackView(arrangedSubviews: [titleDatePlace, carouselCollectionView])
        //        stackView.setCustomSpacing(10, after: titleAnniversary)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //        stackView.distribution = .fillEqually
        stackView.distribution = .fill
        stackView.backgroundColor = .yellow
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func viewWillAppear(_ animated: Bool) {
        if CoupleTabViewModel.changeDarkModeCheck && (RealmManager.shared.getImageDatas().first!.myProfileImageData == nil || RealmManager.shared.getImageDatas().first!.partnerProfileImageData == nil) {
            coupleTabViewModel.updateProfileIcon()
            CoupleTabViewModel.changeDarkModeCheck = false
        }
        
        // 배경사진이 변경됐을때
        //
        if CoupleTabViewModel.changeMainImageCheck {
            coupleTabViewModel.updateMainBackgroundImage()
            CoupleTabViewModel.changeMainImageCheck = false
        }
        // 커플날짜 변경됐을때
        //
        if CoupleTabViewModel.changeCoupleDayMainCheck {
            coupleTabViewModel.updatePublicBeginCoupleDay()
            coupleTabViewModel.updatePublicBeginCoupleFormatterDay()
            CoupleTabViewModel.changeCoupleDayMainCheck = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.firestore.collection("daegu").getDocuments { [self] (querySnapshot, error) in
            guard error == nil else { return }
            for document in querySnapshot!.documents {
                var tempDatePlaceValue = DatePlace()
                print("document.documentID \(document.documentID)")
                print("document.data() \(document.data())")
                print("document.data()[주소] \(document.data()["address"] as! String)")
                
                tempDatePlaceValue.placeName = document.documentID
                tempDatePlaceValue.address = document.data()["address"] as! String
                tempDatePlaceValue.introduce = document.data()["introduce"] as! String
                tempDatePlaceValue.number = document.data()["number"] as! String
                
                mainDatePlaceList.append(tempDatePlaceValue)
            }
            DispatchQueue.main.async { [self] in
                carouselCollectionView.reloadData()
            }
        }
        
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(DemoDatePlaceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        imagePickerController.delegate = self
        
        // 로딩 뷰 세팅, 제일 큰 사진 로딩 끝나면 beforeLoadingSetupView -> afterLoadingSetupView 변경
        // coupleTabViewModel 바인딩 (연결)
        //
        beforeLoadingSetupView()
        coupleTabViewModel.onMainImageDataUpdated = {
            DispatchQueue.main.async { [self] in
                self.mainImageView.image = UIImage(data: self.coupleTabViewModel.mainImageData!)
                afterLoadingSetupView()
                
                // watch, 메인 이미지는 transferUserInfo 방법으로 이미지 연동
                // watch 앱에 보내는 image, 크기 제한이 심해서 0.1 화질로 보냄 -> 0.1이 제일 작은 크기인 듯..? 0.1이 0.01, 0.001 이랑 차이없음
                //
                let data = UIImage(data: self.coupleTabViewModel.mainImageData!)?.jpegData(compressionQuality: 0.1)
                let imageData: [String: Any] = ["imageData": data!]
                WCSession.default.transferUserInfo(imageData)
            }
        }
        coupleTabViewModel.onMyProfileImageDataUpdated = {
            DispatchQueue.main.async {
                self.myProfileUIImageView.image = UIImage(data: self.coupleTabViewModel.myProfileImageData!)
            }
        }
        coupleTabViewModel.onPartnerProfileImageDataUpdated = {
            DispatchQueue.main.async {
                self.partnerProfileUIImageView.image = UIImage(data: self.coupleTabViewModel.partnerProfileImageData!)
            }
        }
        coupleTabViewModel.onPublicBeginCoupleDayUpdated = {
            DispatchQueue.main.async {
                self.mainTextLabel.text = self.coupleTabViewModel.beginCoupleDay
            }
            // watch, days 택스트 value는 updateApplicationContext 방법으로 연동
            //
            let dayData: [String: Any] = ["dayData": String(describing: RealmManager.shared.getUserDatas().first!.beginCoupleDay)]
            try? WCSession.default.updateApplicationContext(dayData)
        }
        
        // viewModel init
        //
        coupleTabViewModel.setMainBackgroundImage()
        coupleTabViewModel.setBeginCoupleDay()
    }
    
    // MARK: Functions
    //
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
        myProfileUIImageView.layer.cornerRadius = profileSize/2 // 둥글게
        myProfileUIImageView.clipsToBounds = true
        
        // 상대방 프로필 사진 변경 제스처
        //
        let tapGesturePartnerProfileUIImageView = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:)))
        partnerProfileUIImageView.isUserInteractionEnabled = true
        partnerProfileUIImageView.addGestureRecognizer(tapGesturePartnerProfileUIImageView)
        partnerProfileUIImageView.layer.cornerRadius = profileSize/2 // 둥글게
        partnerProfileUIImageView.clipsToBounds = true
        
        let imagePartView = imageLoadingFlag ? self.mainImageView : self.mainImageActivityIndicatorView
        
        view.addSubview(coupleTabStackView)
        coupleTabStackView.addArrangedSubview(topTabBackView)
        coupleTabStackView.addArrangedSubview(imagePartView)
        coupleTabStackView.addArrangedSubview(coupleStackView)
        coupleTabStackView.addArrangedSubview(DatePlaceStackView)
        DatePlaceStackView.backgroundColor = .gray
        
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
        coupleTabStackView.setCustomSpacing(15, after: coupleStackView)
        
        // set autolayout
        // UIScreen.main.bounds.size.height -> 디바이스 별 height 이용해서 해상도 비율 맞춤
        //
        NSLayoutConstraint.activate([
            myProfileUIImageView.widthAnchor.constraint(equalToConstant: profileSize),
            myProfileUIImageView.heightAnchor.constraint(equalToConstant: profileSize),
            
            partnerProfileUIImageView.widthAnchor.constraint(equalToConstant: profileSize),
            partnerProfileUIImageView.heightAnchor.constraint(equalToConstant: profileSize),
            
            loveIconView.widthAnchor.constraint(equalToConstant: 30),
            loveIconView.heightAnchor.constraint(equalToConstant: 30),
            
            topTabBackView.topAnchor.constraint(equalTo: view.topAnchor),
            topTabBackView.heightAnchor.constraint(equalToConstant: 80),
            
            imagePartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3),
            imagePartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            imagePartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            coupleStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 45),
            coupleStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -45),
            coupleStackView.heightAnchor.constraint(equalToConstant: coupleStackViewHeightSize),
            
            DatePlaceStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            DatePlaceStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
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
            self.coupleTabViewModel.updateMyProfileImage()
        } else {
            RealmManager.shared.updatePartnerProfileImage(partnerProfileImage: image)
            self.coupleTabViewModel.updatePartnerProfileImage()
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
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .purple
//        return cell
        
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
        return CGSize(width: carouselCollectionView.frame.height - 40, height: carouselCollectionView.frame.height)
    }
}

extension CoupleTabViewController: UICollectionViewDelegate {
    
}
