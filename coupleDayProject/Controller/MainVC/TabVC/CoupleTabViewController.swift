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
    
    private let imagePickerController = UIImagePickerController()
    
    private var whoProfileChange = "my" // 내 프로필변경인지, 상대 프로필변경인지 체크하는 값
    
    static var publicBeginCoupleDay = ""
    static var publicBeginCoupleFormatterDay = ""
    
    private var coupleTabView: CoupleTabView!
    
    private var mainImageData: Data?
    private var myProfileImageData: Data?
    private var partnerProfileImageData: Data?
    
    override func viewWillAppear(_ animated: Bool) {
        setMainBackgroundImage()
        let coupleTabView = CoupleTabView(frame: self.view.frame, mainImageUrl: self.mainImageData!, myProfileImageData: self.myProfileImageData!, partnerProfileImageData: self.partnerProfileImageData!)
        self.view.addSubview(coupleTabView)
        coupleTabView.myProfileAction = setMyProfileTap
        coupleTabView.partnerProfileAction = setPartnerProfileTap
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBeginCoupleDay() // 날짜 세팅
        setMainBackgroundImage() // 메인 이미지 세팅
        setupView() // 뷰 세팅
        
        view.backgroundColor = .white
        
        imagePickerController.delegate = self
    }
    
    // MARK: func
    fileprivate func setMyProfileTap() {
        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
            whoProfileChange = "my"
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    fileprivate func setPartnerProfileTap() {
        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
            whoProfileChange = "partner"
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    fileprivate func setupView() {
        let coupleTabView = CoupleTabView(frame: self.view.frame, mainImageUrl: self.mainImageData!, myProfileImageData: self.myProfileImageData!, partnerProfileImageData: self.partnerProfileImageData!)
        self.view.addSubview(coupleTabView)
        
        // tabView 안에 있는 View 라서 CoupleTavView 안에서 autolayout 설정하면 전체사이즈로 세팅됨. (비율에 안맞음)
        coupleTabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coupleTabView.topAnchor.constraint(equalTo: self.view.topAnchor),
            coupleTabView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            coupleTabView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            coupleTabView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
    fileprivate func setBeginCoupleDay() {
        realm = try? Realm()
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
        CoupleTabViewController.publicBeginCoupleDay = String(describing: minus / 86400000)
        CoupleTabViewController.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
    }
    fileprivate func setMainBackgroundImage() {
        realm = try? Realm()
        let realmImageData = realm.objects(Image.self)
        let mainImageData = realmImageData[0].mainImageData
        let myProfileImageData = realmImageData[0].myProfileImageData
        let partnerProfileImageData = realmImageData[0].partnerProfileImageData
        self.mainImageData = mainImageData
        self.myProfileImageData = myProfileImageData
        self.partnerProfileImageData = partnerProfileImageData
    }
}

// ImagePicker + CropViewController
extension CoupleTabViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    // CropViewController
    func presentCropViewController(image: UIImage) {
        let image: UIImage = image
        let cropViewController = CropViewController(croppingStyle: .circular, image: image) // cropViewController, 범위 둥근 모양
        cropViewController.delegate = self
        cropViewController.aspectRatioLockEnabled = true // 비율 고정
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.doneButtonTitle = "완료"
        cropViewController.cancelButtonTitle = "취소"
        present(cropViewController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        realm = try? Realm()
        let imageData = realm.objects(Image.self)
        try! realm.write {
            if whoProfileChange == "my" {
                imageData.first?.myProfileImageData = image.pngData()
            } else {
                imageData.first?.partnerProfileImageData = image.pngData()
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
