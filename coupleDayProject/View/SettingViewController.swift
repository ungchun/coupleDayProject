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

class SettingViewController: UIViewController{
    
    let imagePickerController = UIImagePickerController()
    
    let defaults = UserDefaults.standard
    
    // MARK: UI
    private lazy var coupleDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "커플 날짜"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setCoupleDayTap)) // label 에 gesture 추가하기
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    private lazy var backgroundImageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배경 사진"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setBackgroundImageTap)) // label 에 gesture 추가하기
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    private lazy var darkModeText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "화면 설정"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setDarkModeTap)) // label 에 gesture 추가하기
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = UIColor(named: "reversebgColor")
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
    fileprivate func setupView() {
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
        self.present(imagePickerController, animated: true, completion: nil)
        //        let photoAuthCheckValue = ImagePicker.photoAuthCheck(imagePickerController: self.imagePickerController)
        //        if photoAuthCheckValue == 0 || photoAuthCheckValue == 3 {
        //            self.present(imagePickerController, animated: true, completion: nil)
        //        }
    }
    @objc
    func setDarkModeTap() {
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        let lightMode = UIAlertAction(title: "주간모드", style: .default) {(action) in
            if let window = UIApplication.shared.windows.first {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .light
                    self.defaults.set(false, forKey: "darkModeState")
                }
            }
        }
        let darkMode = UIAlertAction(title: "야간모드", style: .default) {(action) in
            if let window = UIApplication.shared.windows.first {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .dark
                    self.defaults.set(true, forKey: "darkModeState")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {(action) in
            print("cancel")
        }
        alert.addAction(lightMode)
        alert.addAction(darkMode)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @objc
    func setCoupleDayTap() {
        let datePicker = UIDatePicker() // datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale // datePicker의 default 값이 영어이기 때문에 한글로 바꿔줘야한다. 그래서 이 방식으로 변경할 수 있다.
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        // 최대 날짜 세팅
        components.year = -1
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        // 최소 날짜 세팅
        components.year = -10
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate

        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet) // dateChooserAlert
        dateChooserAlert.view.addSubview(datePicker) // dateChooserAlert에 datePicker 추가
        dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .default, handler: { (action:UIAlertAction!) in // 선택완료 버튼
            
            RealmManager.shared.updateBeginCoupleDay(datePicker: datePicker)
            CoupleTabViewModel.changeCoupleDayMainCheck = true
            CoupleTabViewModel.changeCoupleDayStoryCheck = true
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action:UIAlertAction!) in // 취소 버튼 + 밖에 터치 시 disable
            print("cancel")
        }))
        
        // set datePicker center
        dateChooserAlert.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: dateChooserAlert.view, attribute: .centerX, multiplier: 1, constant: 0))
        dateChooserAlert.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerY, relatedBy: .equal, toItem: dateChooserAlert.view, attribute: .centerY, multiplier: 1, constant: -50)) // -50 하는 이유는 버튼 2개 높이만큼 띄워줘야하는듯..?
        
        // alert content 높이 (datePicker)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        dateChooserAlert.view.addConstraint(height)
        
        present(dateChooserAlert, animated: true, completion: nil)
    }
    
    // MARK: init
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false // 상단 NavigationBar 공간 show
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor // back 버튼 컬러 변경
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal) // back 택스트 폰트 변경
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
        setupView()
        imagePickerController.delegate = self
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
        RealmManager.shared.updateMainImage(mainImage: image)
        CoupleTabViewModel.changeMainImageCheck = true
        dismiss(animated: true, completion: nil)
    }
    // ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = info[.editedImage] is UIImage ? info[UIImagePickerController.InfoKey.editedImage] : info[UIImagePickerController.InfoKey.originalImage]
        self.dismiss(animated: true) { // 이미지피커 dismiis 하고 presentCropViewController 띄우기
            self.presentCropViewController(image: imageData as! UIImage)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
