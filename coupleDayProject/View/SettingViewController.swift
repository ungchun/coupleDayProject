//
//  SettingViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/29.
//

import UIKit
import Photos
import TOCropViewController
import CropViewController
import RealmSwift


class SettingViewController: UIViewController{
    
    var realm: Realm!
    
    let imagePickerController = UIImagePickerController()
//    var imageUrl: NSURL?
    
    // MARK: UI
    private lazy var coupleDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "커플 날짜"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        label.textColor = .black
        return label
    }()
    private lazy var backgroundImageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배경 사진"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        label.textColor = .black
        // label 에 gesture 추가하기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setBackgroundImageTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    private lazy var darkModeText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "다크모드"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        label.textColor = .black
        return label
    }()
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [coupleDayText, backgroundImageText, divider, darkModeText])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 50
        return view
    }()
    
    // MARK: func
    fileprivate func setup() {
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            
            divider.widthAnchor.constraint(equalToConstant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    // MARK: objc
    @objc
    func setBackgroundImageTap() {
        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false // 상단 NavigationBar 공간 show
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor // back 버튼 컬러 변경
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal) // back 택스트 폰트 변경
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        view.backgroundColor = .white
        setup()
        imagePickerController.delegate = self
    }
}

// ImagePicker + CropViewController
extension SettingViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    // CropViewController
    func presentCropViewController(image: UIImage) {
        let image: UIImage = image
//        self.imageUrl = imageUrl
        
        let cropViewController = CropViewController(image: image) // cropViewController
        cropViewController.delegate = self
        cropViewController.setAspectRatioPreset(.preset4x3, animated: true) // 4x3 비율 set
        cropViewController.aspectRatioLockEnabled = true // 비율 고정
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.doneButtonTitle = "완료"
        cropViewController.cancelButtonTitle = "취소"
        present(cropViewController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        realm = try? Realm()
        let imageData = realm.objects(Image.self)
//        let imageUrl = realm.objects(ImageUrl.self)
        
//        let imageString = String(describing: self.imageUrl!)
        
//        print("complete \(self.imageUrl!)")
//        print("complete string \(imageString)")
        
//        let imageUrlRealm = realm.objects(ImageUrl.self)
        
        try! realm.write {
            imageData.first?.mainImageData = image.jpegData(compressionQuality: 0.5)
//            imageUrl.first?.mainImageUrl = imageString
            CoupleTabViewModel.changeMainImageCheck = true
            dismiss(animated: true, completion: nil)
        }
    }
    // ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        self.imageUrl = (info[.imageURL] as! NSURL)
//        print("imageUrl \(self.imageUrl!)")
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
struct SettingViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    // make UI
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        SettingViewController()
    }
}

struct SettingViewController_Previews: PreviewProvider {
    static var previews: some View {
        SettingViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
