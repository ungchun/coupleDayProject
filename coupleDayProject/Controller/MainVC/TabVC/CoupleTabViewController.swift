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
    
    var realm: Realm!

    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값
    
    let coupleTabViewModel = CoupleTabViewModel()
    private let imagePickerController = UIImagePickerController()
    
    // MARK: UI
    private lazy var coupleTabStackView: UIStackView = { // 커플 탭 전체 뷰
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var topTabBackView: UIView = { // 상단 탭 뒤에 뷰
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mainImageView: UIImageView = { // 메인 이미지 뷰
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.image = UIImage(data: self.mainImageData)
        return view
    }()
    private lazy var emptyView: UIView = { // 하단 빈 공간 채우는 뷰
        let view = UIView()
        view.backgroundColor = .gray
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
        view.layer.cornerRadius = 50 // 둥글게
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
//        view.image = UIImage(data: self.myProfileImageData)
        return view
    }()
    private lazy var partnerProfileUIImageView: UIImageView = { // 상대 프로필 뷰
        let view = UIImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(partnerProfileTap(_:))) // 이미지 변경 제스쳐
        view.addGestureRecognizer(tapGesture)
        view.layer.cornerRadius = 50 // 둥글게
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
//        view.image = UIImage(data: self.partnerProfileImageData)
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
    
    private lazy var testLabel_0: UILabel = {
        var label = UILabel()
        label.text = "다가오는 기념일"
        return label
    }()
    private lazy var testLabel_1: UILabel = {
        var label = UILabel()
        label.text = "생일"
        return label
    }()
    private lazy var testLabel_2: UILabel = {
        var label = UILabel()
        label.text = "D-100"
        return label
    }()
    private lazy var testLabel_3: UILabel = {
        var label = UILabel()
        label.text = "로즈데이"
        return label
    }()
    private lazy var comingStoryStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [testLabel_0, testLabel_1, testLabel_2, testLabel_3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
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
    fileprivate func setupView() {
        view.addSubview(coupleTabStackView)
        coupleTabStackView.addArrangedSubview(topTabBackView)
        coupleTabStackView.addArrangedSubview(mainImageView)
        coupleTabStackView.addArrangedSubview(coupleStackView)
        coupleTabStackView.addArrangedSubview(emptyView)
        
        coupleStackView.addArrangedSubview(myProfileUIImageView)
        coupleStackView.addArrangedSubview(iconDayStackView)
        coupleStackView.addArrangedSubview(partnerProfileUIImageView)
        
        iconDayStackView.addArrangedSubview(loveIconView)
        iconDayStackView.addArrangedSubview(mainTextLabel)
        
        NSLayoutConstraint.activate([
            myProfileUIImageView.widthAnchor.constraint(equalToConstant: 100),
            myProfileUIImageView.heightAnchor.constraint(equalToConstant: 100),
            
            partnerProfileUIImageView.widthAnchor.constraint(equalToConstant: 100),
            partnerProfileUIImageView.heightAnchor.constraint(equalToConstant: 100),
            
            loveIconView.widthAnchor.constraint(equalToConstant: 30),
            loveIconView.heightAnchor.constraint(equalToConstant: 30),
            
            topTabBackView.topAnchor.constraint(equalTo: view.topAnchor),
            topTabBackView.heightAnchor.constraint(equalToConstant: 80),
            
            mainImageView.heightAnchor.constraint(equalToConstant: 300),
            coupleStackView.heightAnchor.constraint(equalToConstant: 100),
            
            coupleTabStackView.topAnchor.constraint(equalTo: view.topAnchor),
            coupleTabStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coupleTabStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            coupleTabStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView() // 뷰 세팅

        view.backgroundColor = .white

        imagePickerController.delegate = self
        
        coupleTabViewModel.onMainImageDataUpdated = {
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: self.coupleTabViewModel.mainImageData!)
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
                self.mainTextLabel.text = self.coupleTabViewModel.publicBeginCoupleDay

            }
        }
        
        coupleTabViewModel.setMainBackgroundImage()
        coupleTabViewModel.setBeginCoupleDay()

    }

    

//    var realm: Realm!

//    private let imagePickerController = UIImagePickerController()

//    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값

//    static var publicBeginCoupleDay = ""
//    static var publicBeginCoupleFormatterDay = ""

//    private var coupleTabView: CoupleTabView!

//    private var mainImageData: Data?
//    private var myProfileImageData: Data?
//    private var partnerProfileImageData: Data?

//    override func viewWillAppear(_ animated: Bool) {
//        setMainBackgroundImage()
//        let coupleTabView = CoupleTabView(frame: self.view.frame, mainImageUrl: self.mainImageData!, myProfileImageData: self.myProfileImageData!, partnerProfileImageData: self.partnerProfileImageData!)
//        self.view.addSubview(coupleTabView)
//        coupleTabView.myProfileAction = setMyProfileTap
//        coupleTabView.partnerProfileAction = setPartnerProfileTap
//    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
////        setBeginCoupleDay() // 날짜 세팅
////        setMainBackgroundImage() // 메인 이미지 세팅
////        setupView() // 뷰 세팅
//
//        view.backgroundColor = .white
//
//        imagePickerController.delegate = self
//    }

//    // MARK: func
//    fileprivate func setMyProfileTap() {
//        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
//        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
//            whoProfileChange = "my"
//            self.present(imagePickerController, animated: true, completion: nil)
//        }
//    }
//    fileprivate func setPartnerProfileTap() {
//        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
//        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
//            whoProfileChange = "partner"
//            self.present(imagePickerController, animated: true, completion: nil)
//        }
//    }
//
//    // 뷰 세팅
//    fileprivate func setupView() {
//        let coupleTabView = CoupleTabView(frame: self.view.frame, mainImageUrl: self.mainImageData!, myProfileImageData: self.myProfileImageData!, partnerProfileImageData: self.partnerProfileImageData!)
//        self.view.addSubview(coupleTabView)
//
//        // tabView 안에 있는 View 라서 CoupleTavView 안에서 autolayout 설정하면 전체사이즈로 세팅됨. (비율에 안맞음)
//        coupleTabView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            coupleTabView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            coupleTabView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//            coupleTabView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//            coupleTabView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//        ])
//    }

//    // 날짜 세팅
//    fileprivate func setBeginCoupleDay() {
//        realm = try? Realm()
//        let realmUserData = realm.objects(User.self)
//        let beginCoupleDay = realmUserData[0].beginCoupleDay
//        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
//        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
//        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
//        CoupleTabViewController.publicBeginCoupleDay = String(describing: minus / 86400000)
//        CoupleTabViewController.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
//    }
//
//    // 메인 이미지 세팅
//    fileprivate func setMainBackgroundImage() {
//        realm = try? Realm()
//        let realmImageData = realm.objects(Image.self)
//        let mainImageData = realmImageData[0].mainImageData
//        let myProfileImageData = realmImageData[0].myProfileImageData
//        let partnerProfileImageData = realmImageData[0].partnerProfileImageData
//        self.mainImageData = mainImageData
//        self.myProfileImageData = myProfileImageData
//        self.partnerProfileImageData = partnerProfileImageData
//    }
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
                print("if whoProfileChange")
                imageData.first?.myProfileImageData = image.jpegData(compressionQuality: 0.5)
                self.coupleTabViewModel.updateMyProfileImage()
            } else {
                print("else whoProfileChange")
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

#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    // make UI
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        CoupleTabViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
