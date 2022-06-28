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
    
    // MARK: 포토 권한 분기처리 권한설정안해도 돌아감..
    private func photoAuthCheck() {
        let status = PHPhotoLibrary.authorizationStatus().rawValue
        print("status \(status)")
        switch status {
        case 0:
            // .notDetermined - 사용자가 아직 권한에 대한 설정을 하지 않았을 때
            print("CALLBACK FAILED: is .notDetermined")
            self.imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        case 1:
            // .restricted - 시스템에 의해 앨범에 접근 불가능하고, 권한 변경이 불가능한 상태
            print("CALLBACK FAILED: is .restricted")
        case 2:
            // .denied - 접근이 거부된 경우
            print("CALLBACK FAILED: is .denied")
            let alert = UIAlertController(title: "권한요청", message: "권한이 필요합니다. 권한 설정 화면으로 이동합니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                if (UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)){
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        case 3:
            // .authorized - 권한 허용된 상태
            print("CALLBACK SUCCESS: is .authorized")
            self.imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        case 4:
            // .limited (iOS 14 이상 사진 라이브러리 전용) - 갤러리의 접근이 선택한 사진만 허용된 경우
            print("CALLBACK SUCCESS: is .limited")
        default:
            // 그 외의 경우 - 미래에 새로운 권한 추가에 대비
            print("CALLBACK FAILED: is unknwon state.")
        }
    }
    
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
        photoAuthCheck()
    }
}

extension SettingViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
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
