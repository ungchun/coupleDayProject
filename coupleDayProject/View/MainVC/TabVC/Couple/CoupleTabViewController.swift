//
//  ViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/22.
//

import UIKit
import Photos
import TOCropViewController
import CropViewController
import GoogleMobileAds
import WatchConnectivity

class CoupleTabViewController: UIViewController {
    //    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    //    }
    //
    //    func sessionDidBecomeInactive(_ session: WCSession) {
    //
    //    }
    //
    //    func sessionDidDeactivate(_ session: WCSession) {
    //
    //    }
    //
    //
    //    var session: WCSession?
    //
    //    func configureWatchKitSesstion() {
    //
    //        if WCSession.isSupported() {
    //            session = WCSession.default
    //            session?.delegate = self
    //            session?.activate()
    //        }
    //    }
    
    private let coupleTabViewModel = CoupleTabViewModel()
    
    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값
    private let imagePickerController = UIImagePickerController()
    
    private let mainImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 메인 이미지 로딩 뷰
    private let myProfileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 내 프로필 이미지 로딩 뷰
    private let profileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 상대 프로필 이미지 로딩 뷰
    
    private let textBigSize = UIScreen.main.bounds.size.height > 900 ? 33.0 : UIScreen.main.bounds.size.height > 840 ? 27.0 : UIScreen.main.bounds.size.height > 750 ? 23.0 : 20.0
    private let textSmallSize = UIScreen.main.bounds.size.height > 900 ? 22.0 : UIScreen.main.bounds.size.height > 840 ? 20.0 : UIScreen.main.bounds.size.height > 840 ? 17.0 : 15.0
    
    private let profileSize = UIScreen.main.bounds.size.height > 750 ? 70.0 : 60.0
    
    private let coupleStackViewHeightSize = UIScreen.main.bounds.size.height > 750 ? UIScreen.main.bounds.size.height / 8 : UIScreen.main.bounds.size.height / 10
    
    // MARK: UI
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
    
    // MARK: admob 부분
    private let demoAdmobView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    //    private let demoAdmobView: GADBannerView = {
    //        var view = GADBannerView()
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        return view
    //    }()
    
    private lazy var comingStoryStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [titleAnniversary, anniversaryOneStackView, anniversaryTwoStackView, anniversaryThreeStackView, anniversaryEmpty])
        stackView.setCustomSpacing(10, after: titleAnniversary)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: objc
    @objc
    func myProfileTap(_ gesture: UITapGestureRecognizer) { // 내 사진 변경
        whoProfileChange = "my"
        self.present(imagePickerController, animated: true, completion: nil)
        //        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        //        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
        //            whoProfileChange = "my"
        //            self.present(imagePickerController, animated: true, completion: nil)
        //        }
    }
    @objc
    func partnerProfileTap(_ gesture: UITapGestureRecognizer) { // 상대 사진 변경
        whoProfileChange = "partner"
        self.present(imagePickerController, animated: true, completion: nil)
        //        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        //        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
        //            whoProfileChange = "partner"
        //            self.present(imagePickerController, animated: true, completion: nil)
        //        }
    }
    
    // MARK: func
    // 이미지 불러오는동안 보이는 임시 뷰
    fileprivate func beforeLoadingSetupView() {
        view.backgroundColor = UIColor(named: "bgColor")
        // 이미지 로딩 뷰
        mainImageActivityIndicatorView.startAnimating()
        mainImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        myProfileImageActivityIndicatorView.startAnimating()
        myProfileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        profileImageActivityIndicatorView.startAnimating()
        profileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpView(imageLoadingFlag: false)
    }
    
    // 이미지 불러오고나서 보이는 뷰
    fileprivate func afterLoadingSetupView() {
        view.backgroundColor = UIColor(named: "bgColor")
        // 이미지 로딩 뷰 제거
        profileImageActivityIndicatorView.stopAnimating()
        myProfileImageActivityIndicatorView.stopAnimating()
        mainImageActivityIndicatorView.stopAnimating()
        
        setUpView(imageLoadingFlag: true)
    }
    
    fileprivate func setUpView(imageLoadingFlag: Bool) {
        
        // 내 사진 변경
        let tapGestureMyProfileUIImageView = UITapGestureRecognizer(target: self, action: #selector(myProfileTap(_:))) // 이미지 변경 제스쳐
        myProfileUIImageView.addGestureRecognizer(tapGestureMyProfileUIImageView)
        myProfileUIImageView.isUserInteractionEnabled = true
        myProfileUIImageView.layer.cornerRadius = profileSize/2 // 둥글게
        myProfileUIImageView.clipsToBounds = true
        
        // 상대방 사진 변경
        let tapGesturePartnerProfileUIImageView = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:))) // 이미지 변경 제스쳐
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
        
        coupleTabStackView.addArrangedSubview(demoAdmobView)
        
        //        coupleTabStackView.addArrangedSubview(demoAdmobView)
        
        demoAdmobView.widthAnchor.constraint(equalToConstant: GADAdSizeBanner.size.width).isActive = true
        demoAdmobView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height).isActive = true
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
        
        // UIScreen.main.bounds.size.height -> 디바이스 별 height 이용해서 해상도 비율 맞춤
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
    
    // MARK: init
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
        
        //        self.configureWatchKitSesstion()
        
        // 로딩 뷰 세팅
        //
        beforeLoadingSetupView()
        //        afterLoadingSetupView()
        
        imagePickerController.delegate = self
        
        coupleTabViewModel.onMainImageDataUpdated = {
            DispatchQueue.main.async { [self] in
                self.mainImageView.image = UIImage(data: self.coupleTabViewModel.mainImageData!)
                afterLoadingSetupView() // 제일 큰 사진 로딩 끝나면 beforeLoadingSetupView -> afterLoadingSetupView
                
                print("@@@@ self.coupleTabViewModel.mainImageData! \(self.coupleTabViewModel.mainImageData!)")
                let data = UIImage(data: self.coupleTabViewModel.mainImageData!)?.jpegData(compressionQuality: 0.1)
                print("@@@@ after data 0.1 \(data!)")
                let data2 = UIImage(data: self.coupleTabViewModel.mainImageData!)?.jpegData(compressionQuality: 0.01)
                print("@@@@ after data 0.01 \(data2!)")
                let data3 = UIImage(data: self.coupleTabViewModel.mainImageData!)?.jpegData(compressionQuality: 0.001)
                print("@@@@ after data 0.01 \(data3!)")
                
                guard WCSession.default.activationState == .activated else { return }
                do {
                    print("do do do")
                    //                    let imageData: [String: Any] = ["sunghun": self.coupleTabViewModel.mainImageData!]
                    let imageData: [String: Any] = ["sunghun": data!]
                    try WCSession.default.updateApplicationContext(imageData)
                } catch {
                    print("catch error \(error.localizedDescription)")
                }
                
            }
            
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
            
            // transferUserInfo
            //
            let dayData: [String: Any] = ["dayData": String(describing: RealmManager.shared.getUserDatas().first!.beginCoupleDay)]
            WCSession.default.transferUserInfo(dayData)
            
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
        coupleTabViewModel.setMainBackgroundImage()
        coupleTabViewModel.setBeginCoupleDay()
        coupleTabViewModel.setAnniversary()
    }
}

// ImagePicker + CropViewController
extension CoupleTabViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    // CropViewController
    func presentCropViewController(image: UIImage) {
        let image: UIImage = image
        let cropViewController = CropViewController(croppingStyle: .circular, image: image) // cropViewController, 이미지 범위 둥근 모양
        cropViewController.delegate = self
        cropViewController.aspectRatioLockEnabled = true // 비율 고정
        cropViewController.aspectRatioPickerButtonHidden = true // 비율 설정하는 프리셋 버튼 hidden
        cropViewController.doneButtonTitle = "완료"
        cropViewController.cancelButtonTitle = "취소"
        present(cropViewController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        if whoProfileChange == "my" { // 내 프로필 변경
            RealmManager.shared.updateMyProfileImage(myProfileImage: image)
            self.coupleTabViewModel.updateMyProfileImage()
        } else { // 상대 프로필 변경
            RealmManager.shared.updatePartnerProfileImage(partnerProfileImage: image)
            self.coupleTabViewModel.updatePartnerProfileImage()
        }
        dismiss(animated: true, completion: nil)
    }
    // ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = info[.editedImage] is UIImage ? info[UIImagePickerController.InfoKey.editedImage] : info[UIImagePickerController.InfoKey.originalImage]
        dismiss(animated: true) {
            self.presentCropViewController(image: imageData as! UIImage)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
