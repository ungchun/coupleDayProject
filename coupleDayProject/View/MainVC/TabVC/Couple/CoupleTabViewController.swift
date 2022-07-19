import UIKit
import Photos
import TOCropViewController
import CropViewController
import GoogleMobileAds
import WatchConnectivity

class CoupleTabViewController: UIViewController {
    
    private let coupleTabViewModel = CoupleTabViewModel()
    
    private let imagePickerController = UIImagePickerController()
    
    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값
    
    private let mainImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 메인 이미지 로딩 뷰
    private let myProfileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 내 프로필 이미지 로딩 뷰
    private let profileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 상대 프로필 이미지 로딩 뷰
    
    private let textBigSize = UIScreen.main.bounds.size.height > 900 ? 33.0 : UIScreen.main.bounds.size.height > 840 ? 27.0 : UIScreen.main.bounds.size.height > 750 ? 23.0 : 20.0
    private let textSmallSize = UIScreen.main.bounds.size.height > 900 ? 22.0 : UIScreen.main.bounds.size.height > 840 ? 20.0 : UIScreen.main.bounds.size.height > 840 ? 17.0 : 15.0
    private let profileSize = UIScreen.main.bounds.size.height > 750 ? 70.0 : 60.0
    private let coupleStackViewHeightSize = UIScreen.main.bounds.size.height > 750 ? UIScreen.main.bounds.size.height / 8 : UIScreen.main.bounds.size.height / 10
    
    // MARK: UI
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
    private lazy var titleAnniversary: UILabel = {
        var label = UILabel()
        label.text = "다가오는 기념일"
        label.font = UIFont(name: "GangwonEduAllBold", size: textBigSize)
        return label
    }()
    private lazy var anniversaryOneContent: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var anniversaryOneD_Day: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var anniversaryOneStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [anniversaryOneContent, anniversaryOneD_Day])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var anniversaryTwoContent: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var anniversaryTwoD_Day: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var anniversaryTwoStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [anniversaryTwoContent, anniversaryTwoD_Day])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var anniversaryThreeContent: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var anniversaryThreeD_Day: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var anniversaryThreeStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [anniversaryThreeContent, anniversaryThreeD_Day])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    private let anniversaryEmpty: UILabel = {
        var label = UILabel()
        return label
    }()
    private let demoAdmobView: UIView = { // admob 부분
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    // admob 제대로 달고 위에 demo 버전 UIView 삭제
    //    private let demoAdmobView: GADBannerView = {
    //        var view = GADBannerView()
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        return view
    //    }()
    private lazy var comingStoryStackView: UIStackView = { // 다가오는 기념일 stackView
        var stackView = UIStackView(arrangedSubviews: [titleAnniversary, anniversaryOneStackView, anniversaryTwoStackView, anniversaryThreeStackView, anniversaryEmpty])
        stackView.setCustomSpacing(10, after: titleAnniversary)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: init
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
            
            // guard WCSession.default.activationState 말고 이렇게도 가능함, 블로그 작성 후 요부분 삭제
            //            if let validSession = self.session {
            //                let data: [String: Any] = ["imageData": RealmManager.shared.getImageDatas().first!.mainImageData!]
            //                validSession.transferUserInfo(data)
            //            }
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
            
            // WCSession.default.transferUserInfo(dayData) 말고 이렇게도 가능함, 블로그 작성 후 요부분 삭제
            //            if let validSession = self.session {
            //                let data: [String: Any] = ["dayData": self.coupleTabViewModel.beginCoupleDay]
            //                validSession.transferUserInfo(data)
            //            }
        }
        coupleTabViewModel.onAnniversaryOneUpdated = {
            DispatchQueue.main.async {
                self.anniversaryOneContent.text = self.coupleTabViewModel.anniversaryOne
            }
        }
        coupleTabViewModel.onAnniversaryOneD_DayUpdated = {
            DispatchQueue.main.async {
                self.anniversaryOneD_Day.text = self.coupleTabViewModel.anniversaryOneD_Day
            }
        }
        coupleTabViewModel.onAnniversaryTwoUpdated = {
            DispatchQueue.main.async {
                self.anniversaryTwoContent.text = self.coupleTabViewModel.anniversaryTwo
            }
        }
        coupleTabViewModel.onAnniversaryTwoD_DayUpdated = {
            DispatchQueue.main.async {
                self.anniversaryTwoD_Day.text = self.coupleTabViewModel.anniversaryTwoD_Day
            }
        }
        coupleTabViewModel.onAnniversaryThreeUpdated = {
            DispatchQueue.main.async {
                self.anniversaryThreeContent.text = self.coupleTabViewModel.anniversaryThree
            }
        }
        coupleTabViewModel.onAnniversaryThreeD_DayUpdated = {
            DispatchQueue.main.async {
                self.anniversaryThreeD_Day.text = self.coupleTabViewModel.anniversaryThreeD_Day
            }
        }
        
        // viewModel init
        //
        coupleTabViewModel.setMainBackgroundImage()
        coupleTabViewModel.setBeginCoupleDay()
        coupleTabViewModel.setAnniversary()
    }
    
    // MARK: func
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
        coupleTabStackView.addArrangedSubview(comingStoryStackView)
        //                coupleTabStackView.addArrangedSubview(demoAdmobView)
        //
        //                demoAdmobView.widthAnchor.constraint(equalToConstant: GADAdSizeBanner.size.width).isActive = true
        //                demoAdmobView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height).isActive = true
        //        demoAdmobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //        demoAdmobView.rootViewController = self
        //        demoAdmobView.load(GADRequest())
        
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
            
            comingStoryStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            comingStoryStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            coupleTabStackView.topAnchor.constraint(equalTo: view.topAnchor),
            coupleTabStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            coupleTabStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            coupleTabStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    // MARK: objc
    //
    @objc
    func myProfileTap(_ gesture: UITapGestureRecognizer) {
        whoProfileChange = "my"
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @objc
    func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
        whoProfileChange = "partner"
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: extension
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
