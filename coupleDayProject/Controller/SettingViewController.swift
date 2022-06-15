//
//  SettingViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/05/29.
//

import UIKit

class SettingViewController: UIViewController {
    
    private var settingView: SettingView!
    
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
        imagePickerController.allowsEditing = true // 수정 가능 여부
        imagePickerController.delegate = self
    }
    
    // MARK: func
    fileprivate func setupView() {
        let settingView = SettingView(frame: self.view.frame)
        self.settingView = SettingView()
        self.view.addSubview(settingView)
        settingView.setBackgroundImageAction = setBackgroundImageTap
    }
    
    fileprivate func setBackgroundImageTap() {
        print("배경사진 변경")
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension SettingViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print(info)
            
            dismiss(animated: true, completion: nil)
            let imageCheckVC = ImageCheckViewController()
            imageCheckVC.image = image
            self.present(imageCheckVC, animated: true, completion: nil)
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
