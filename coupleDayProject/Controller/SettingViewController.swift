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
        setupView()
        imagePickerController.delegate = self
    }
    
    // MARK: func
    fileprivate func setupView() {
        let settingView = SettingView(frame: self.view.frame)
        self.view.addSubview(settingView)
        settingView.setBackgroundImageAction = setBackgroundImageTap
    }
    
    fileprivate func setBackgroundImageTap() {
        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

// ImagePicker + CropViewController
extension SettingViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    // CropViewController
    func presentCropViewController(image: UIImage) {
        let image: UIImage = image
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
        try! realm.write {
            imageData.first?.mainImageData = image.pngData()
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
