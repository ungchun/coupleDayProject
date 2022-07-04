//
//  ViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/22.
//

import UIKit
import RealmSwift
import Photos
import TOCropViewController
import CropViewController

class CoupleTabViewController: UIViewController {
    
    let coupleTabViewModel = CoupleTabViewModel()
    
    var realm: Realm!
    
    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값
    private let imagePickerController = UIImagePickerController()
    
    let mainImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 메인 이미지 로딩 뷰
    let myProfileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 내 프로필 이미지 로딩 뷰
    let profileImageActivityIndicatorView =  UIActivityIndicatorView(style: .medium) // 상대 프로필 이미지 로딩 뷰
    
    let textBigSize = UIScreen.main.bounds.size.height > 750 ? 30.0 : 25.0
    let textSmallSize = UIScreen.main.bounds.size.height > 750 ? 20.0 : 15.0
    
    // MARK: UI
    private lazy var coupleTabStackView: UIStackView = { // 커플 탭 전체 뷰
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        return view
    }()
    private lazy var topTabBackView: UIView = { // 상단 탭 뒤에 뷰
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mainImageView: UIImageView = { // 메인 이미지 뷰
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var emptyView: UIView = { // 하단 빈 공간 채우는 뷰
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var coupleStackView: UIStackView = { // 내 프로필 + day + 상대 프로필
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var myProfileUIImageView: UIImageView = { // 내 프로필 뷰
        let view = UIImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myProfileTap(_:))) // 이미지 변경 제스쳐
        view.addGestureRecognizer(tapGesture)
        view.layer.cornerRadius = 55 // 둥글게
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var partnerProfileUIImageView: UIImageView = { // 상대 프로필 뷰
        let view = UIImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:))) // 이미지 변경 제스쳐
        view.addGestureRecognizer(tapGesture)
        view.layer.cornerRadius = 55 // 둥글게
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var iconDayStackView: UIStackView = { // 하트 아이콘 + day
       let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var loveIconView: UIImageView = { // 하트 아이콘
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = TrendingConstants.appMainColor
        return view
    }()
    lazy var mainTextLabel: UILabel = { // day
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "GangwonEduAllLight", size: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var titleAnniversary: UILabel = {
        var label = UILabel()
        label.text = "다가오는 기념일"
        label.font = UIFont(name: "GangwonEduAllBold", size: textBigSize)
        label.textColor = .black
        return label
    }()
    private lazy var contentAnniversaryOne: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var contentAnniversaryTwo: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var contentAnniversaryThree: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GangwonEduAllLight", size: textSmallSize)
        return label
    }()
    private lazy var contentAnniversaryEmpty: UILabel = {
        var label = UILabel()
        return label
    }()
    private lazy var comingStoryStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [titleAnniversary, contentAnniversaryOne, contentAnniversaryTwo, contentAnniversaryThree, contentAnniversaryEmpty])
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
        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
            whoProfileChange = "my"
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @objc
    func partnerProfileTap(_ gesture: UITapGestureRecognizer) { // 상대 사진 변경
        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
            whoProfileChange = "partner"
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: func
    // 이미지 불러오는동안 보이는 임시 뷰
    fileprivate func beforeLoadingSetupView() {
        view.backgroundColor = .white
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
        view.backgroundColor = .white
        // 이미지 로딩 뷰 제거
        profileImageActivityIndicatorView.stopAnimating()
        myProfileImageActivityIndicatorView.stopAnimating()
        mainImageActivityIndicatorView.stopAnimating()
        
        setUpView(imageLoadingFlag: true)
    }
    
    fileprivate func setUpView(imageLoadingFlag: Bool) {
        
        let imagePartView = imageLoadingFlag ? self.mainImageView : self.mainImageActivityIndicatorView
        
        view.addSubview(coupleTabStackView)
        
        coupleTabStackView.addArrangedSubview(topTabBackView)
        coupleTabStackView.addArrangedSubview(imagePartView)
        coupleTabStackView.addArrangedSubview(coupleStackView)
        coupleTabStackView.addArrangedSubview(comingStoryStackView)
        
        coupleStackView.addArrangedSubview(myProfileUIImageView)
        coupleStackView.addArrangedSubview(iconDayStackView)
        coupleStackView.addArrangedSubview(partnerProfileUIImageView)
        
        iconDayStackView.addArrangedSubview(loveIconView)
        iconDayStackView.addArrangedSubview(mainTextLabel)
        
        coupleTabStackView.setCustomSpacing(25, after: imagePartView)
        coupleTabStackView.setCustomSpacing(25, after: coupleStackView)
        
        NSLayoutConstraint.activate([
            myProfileUIImageView.widthAnchor.constraint(equalToConstant: 110),
            myProfileUIImageView.heightAnchor.constraint(equalToConstant: 110),
            
            partnerProfileUIImageView.widthAnchor.constraint(equalToConstant: 110),
            partnerProfileUIImageView.heightAnchor.constraint(equalToConstant: 110),
            
            loveIconView.widthAnchor.constraint(equalToConstant: 30),
            loveIconView.heightAnchor.constraint(equalToConstant: 30),
            
            topTabBackView.topAnchor.constraint(equalTo: view.topAnchor),
            topTabBackView.heightAnchor.constraint(equalToConstant: 80),
            
            imagePartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3),
            imagePartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            imagePartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            coupleStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            coupleStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            coupleStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 7),
                    
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
        print("UIScreen.main.bounds.size.height \(UIScreen.main.bounds.size.height)")
        // 배경사진이 변경됐을때
        if CoupleTabViewModel.changeMainImageCheck {
            coupleTabViewModel.updateMainBackgroundImage()
            CoupleTabViewModel.changeMainImageCheck = false
        }
        // 커플날짜 변경됐을때
        if CoupleTabViewModel.changeCoupleDayMainCheck {
            coupleTabViewModel.updatePublicBeginCoupleDay()
            coupleTabViewModel.updatePublicBeginCoupleFormatterDay()
            CoupleTabViewModel.changeCoupleDayMainCheck = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        beforeLoadingSetupView() // 로딩 뷰 세팅

        imagePickerController.delegate = self
        
        // 바인딩
        coupleTabViewModel.onMainImageDataUpdated = {
            DispatchQueue.main.async { [self] in
                self.mainImageView.image = UIImage(data: self.coupleTabViewModel.mainImageData!)
                afterLoadingSetupView() // 제일 큰 사진 로딩 끝나면 beforeLoadingSetupView -> afterLoadingSetupView
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
        }
        
        coupleTabViewModel.onAnniversaryOneUpdated = {
            DispatchQueue.main.async {
                self.contentAnniversaryOne.text = self.coupleTabViewModel.anniversaryOne
            }
        }
        coupleTabViewModel.onAnniversaryTwoUpdated = {
            DispatchQueue.main.async {
                self.contentAnniversaryTwo.text = self.coupleTabViewModel.anniversaryTwo
            }
        }
        coupleTabViewModel.onAnniversaryThreeUpdated = {
            DispatchQueue.main.async {
                self.contentAnniversaryThree.text = self.coupleTabViewModel.anniversaryThree
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
        realm = try? Realm()
        let imageData = realm.objects(Image.self)
        try! realm.write {
            if whoProfileChange == "my" {
                imageData.first?.myProfileImageData = image.jpegData(compressionQuality: 0.5)
                self.coupleTabViewModel.updateMyProfileImage()
            } else {
                imageData.first?.partnerProfileImageData = image.jpegData(compressionQuality: 0.5)
                self.coupleTabViewModel.updatePartnerProfileImage()
            }
            dismiss(animated: true, completion: nil)
        }
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
