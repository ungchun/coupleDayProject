import UIKit
import Photos
import TOCropViewController
import CropViewController

class SettingViewController: UIViewController{
    
    private let imagePickerController = UIImagePickerController()
    private let defaults = UserDefaults.standard
    
    // MARK: UI
    //
    private let coupleDayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "커플 날짜"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private let backgroundImageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배경 사진"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private let darkModeText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "화면 설정"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = UIColor(named: "reversebgColor")
        return view
    }()
    private lazy var stackView: UIStackView = { // settingView label stackView
        let view = UIStackView(arrangedSubviews: [coupleDayText, backgroundImageText, divider, darkModeText])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 50
        return view
    }()
    
    // MARK: init
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 상단 NavigationBar 공간 show (뒤로가기 버튼)
        //
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back 버튼 컬러 변경, 택스트 폰트 변경
        //
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
        imagePickerController.delegate = self
        setupView()
    }
    
    // MARK: func
    //
    fileprivate func setupView() {
        self.view.addSubview(stackView)
        
        // 날짜 변경 label에 제스처 추가
        //
        let tapGestureCoupleDayText = UITapGestureRecognizer(target: self, action: #selector(setCoupleDayTap))
        coupleDayText.isUserInteractionEnabled = true
        coupleDayText.addGestureRecognizer(tapGestureCoupleDayText)
        
        // 배경 사진 변경 label에 제스처 추가
        //
        let tapGestureBackgroundImageText = UITapGestureRecognizer(target: self, action: #selector(setBackgroundImageTap))
        backgroundImageText.isUserInteractionEnabled = true
        backgroundImageText.addGestureRecognizer(tapGestureBackgroundImageText)
        
        // 다크모드 label에 제스처 추가
        //
        let tapGestureDarkModeText = UITapGestureRecognizer(target: self, action: #selector(setDarkModeTap))
        darkModeText.isUserInteractionEnabled = true
        darkModeText.addGestureRecognizer(tapGestureDarkModeText)
        
        // set autolayout
        //
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    // MARK: objc
    //
    @objc
    func setBackgroundImageTap() {
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @objc
    func setDarkModeTap() {
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        let lightMode = UIAlertAction(title: "주간모드", style: .default) {(action) in
            if let window = UIApplication.shared.windows.first {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .light
                    self.defaults.set(false, forKey: "darkModeState")
                    CoupleTabViewModel.changeDarkModeCheck = true
                }
            }
        }
        let darkMode = UIAlertAction(title: "야간모드", style: .default) {(action) in
            if let window = UIApplication.shared.windows.first {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .dark
                    self.defaults.set(true, forKey: "darkModeState")
                    CoupleTabViewModel.changeDarkModeCheck = true
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
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // datePicker의 default 값이 영어이기 때문에 한글로 바꿔줘야한다. 그래서 이 방식으로 변경할 수 있다.
        //
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        // datePicker max 날짜 세팅 -> 오늘 날짜 에서
        //
        components.year = -1
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        // datePicker min 날짜 세팅 -> 30년 전 까지
        //
        components.year = -30
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        // dateChooserAlert에 datePicker, 선택완료 버튼 추가
        //
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .default, handler: { (action:UIAlertAction!) in
            RealmManager.shared.updateBeginCoupleDay(datePicker: datePicker)
            CoupleTabViewModel.changeCoupleDayMainCheck = true
            CoupleTabViewModel.changeCoupleDayStoryCheck = true
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action:UIAlertAction!) in
            print("cancel")
        }))
        
        // set datePicker center
        //
        dateChooserAlert.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: dateChooserAlert.view, attribute: .centerX, multiplier: 1, constant: 0))
        dateChooserAlert.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerY, relatedBy: .equal, toItem: dateChooserAlert.view, attribute: .centerY, multiplier: 1, constant: -50)) // -50 하는 이유는 버튼 2개 높이만큼 띄워줘야하는듯..?
        
        // alert content 높이 (datePicker)
        //
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        dateChooserAlert.view.addConstraint(height)
        
        present(dateChooserAlert, animated: true, completion: nil)
    }
}

// MARK: extension
//
// ImagePicker + CropViewController
//
extension SettingViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    // ImagePicker
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = info[.editedImage] is UIImage ? info[UIImagePickerController.InfoKey.editedImage] : info[UIImagePickerController.InfoKey.originalImage]
        
        // 이미지 고르면 이미지피커 dismiis 하고 이미지 데이터 넘기면서 presentCropViewController 띄우기
        //
        self.dismiss(animated: true) {
            self.presentCropViewController(image: imageData as! UIImage)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // CropViewController
    // 4x3 비율 set, aspectRatioLockEnabled -> 비율 고정
    //
    func presentCropViewController(image: UIImage) {
        let image: UIImage = image
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.setAspectRatioPreset(.preset4x3, animated: true)
        cropViewController.aspectRatioLockEnabled = true
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
}
