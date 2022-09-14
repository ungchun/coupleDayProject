import UIKit
import Photos
import TOCropViewController
import CropViewController

final class SettingViewController: UIViewController{
    
    private var coupleTabViewModel: CoupleTabViewModel?
    init(coupleTabViewModel: CoupleTabViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coupleTabViewModel = coupleTabViewModel
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    //
    private let imagePickerController = UIImagePickerController()
    private let userDefaults = UserDefaults.standard
    weak var coordinator: SettingViewCoordinator?
    
    // MARK: Views
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
    private lazy var allContentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [coupleDayText, backgroundImageText, divider, darkModeText])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 50
        return view
    }()
    
    // MARK: Life Cycle
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 상단 NavigationBar 공간 show (뒤로가기 버튼)
        //
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        
        setUpBackBtn()
        setUpView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishSettingView()
    }
    
    // MARK: Functions
    //
    private func setUpView() {
        self.view.addSubview(allContentStackView)
        
        let tapGestureCoupleDayText = UITapGestureRecognizer(target: self, action: #selector(setCoupleDayTap))
        coupleDayText.isUserInteractionEnabled = true
        coupleDayText.addGestureRecognizer(tapGestureCoupleDayText)
        
        let tapGestureBackgroundImageText = UITapGestureRecognizer(target: self, action: #selector(setBackgroundImageTap))
        backgroundImageText.isUserInteractionEnabled = true
        backgroundImageText.addGestureRecognizer(tapGestureBackgroundImageText)
        
        let tapGestureDarkModeText = UITapGestureRecognizer(target: self, action: #selector(setDarkModeTap))
        darkModeText.isUserInteractionEnabled = true
        darkModeText.addGestureRecognizer(tapGestureDarkModeText)
        
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            allContentStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            allContentStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    private func setUpBackBtn() {
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
    }
    @objc func setBackgroundImageTap() {
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @objc func setDarkModeTap() {
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        let lightMode = UIAlertAction(title: "주간모드", style: .default) {(action) in
            if let window = UIApplication.shared.windows.first {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .light
                    self.userDefaults.set(false, forKey: "darkModeState")
                    CoupleTabViewModel.changeDarkModeCheck = true
                }
            }
        }
        let darkMode = UIAlertAction(title: "야간모드", style: .default) {(action) in
            if let window = UIApplication.shared.windows.first {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .dark
                    self.userDefaults.set(true, forKey: "darkModeState")
                    CoupleTabViewModel.changeDarkModeCheck = true
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {(action) in }
        alert.addAction(lightMode)
        alert.addAction(darkMode)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @objc func setCoupleDayTap() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // datePicker의 default 값이 영어 -> 한글로 변경
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
        let maxDate = calendar.date(byAdding: components, to: currentDate)
        
        // datePicker min 날짜 세팅 -> 30년 전 까지
        //
        components.year = -31
        let minDate = calendar.date(byAdding: components, to: currentDate)
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .default, handler: { [self] (action:UIAlertAction!) in
            RealmManager.shared.updateBeginCoupleDay(datePicker: datePicker)
            coupleTabViewModel?.setBeginCoupleDay()
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action:UIAlertAction!) in }))
        
        dateChooserAlert.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: dateChooserAlert.view, attribute: .centerX, multiplier: 1, constant: 0))
        dateChooserAlert.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .centerY, relatedBy: .equal, toItem: dateChooserAlert.view, attribute: .centerY, multiplier: 1, constant: -50)) // -50 하는 이유는 버튼 2개 높이만큼 띄워줘야하는듯..?
        
        let alertContentHeight: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        dateChooserAlert.view.addConstraint(alertContentHeight)
        
        present(dateChooserAlert, animated: true, completion: nil)
    }
}

// MARK: Extension
//
extension SettingViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = info[.editedImage] is UIImage ? info[UIImagePickerController.InfoKey.editedImage] : info[UIImagePickerController.InfoKey.originalImage]
        self.dismiss(animated: true) {
            self.presentCropViewController(image: imageData as! UIImage)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentCropViewController(image: UIImage) {
        let image: UIImage = image
        let cropViewController = CropViewController(image: image)
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
        coupleTabViewModel?.setMainBackgroundImage()
        dismiss(animated: true, completion: nil)
    }
}
